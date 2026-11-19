"""API-05 : authentification, liste blanche, bornes, propagation des identifiants, événements d'usage.

Prototypes : PO-11 (limites par abonnement en Consumption), PO-12 (streaming), PO-13 (non-contournement de Foundry).
Les tests qui appellent un modèle sont ignorés tant qu'aucun alias n'est actif dans le catalogue.
"""
import os
import time
import uuid
from concurrent.futures import ThreadPoolExecutor

import pytest
import requests

from conftest import az


def corps(alias, **extra):
    return {"model": alias, "input": "Réponds uniquement : ok", "max_output_tokens": 16, **extra}


def code_erreur(r):
    return r.json().get("error", {}).get("code")


# --- Authentification (IAM-01, IAM-03)

def test_sans_jeton_refuse(appel):
    r = appel(corps("agent-general"), jeton_="")
    assert r.status_code == 401


def test_jeton_mauvaise_audience_refuse(appel):
    autre = az("account", "get-access-token", "--resource", "https://management.azure.com/", "--query", "accessToken")
    r = appel(corps("agent-general"), jeton_=autre)
    assert r.status_code == 401
    assert code_erreur(r) == "unauthorized"


def test_sans_cle_abonnement_refuse(appel):
    r = appel(corps("agent-general"), cle_="")
    assert r.status_code == 401


# --- Liste blanche et bornes (MGW-02, GRD-03)

def test_alias_inconnu_refuse(appel):
    r = appel(corps("modele-inexistant"))
    assert r.status_code == 400
    assert code_erreur(r) == "model_not_allowed"
    assert "x-trace-id" in r.headers


def test_parametre_interdit_refuse(appel, catalogue):
    if not catalogue["actifs"]:
        pytest.skip("aucun alias actif")
    interdits = catalogue["commun"]["gateway_policy"]["forbidden_parameters"]
    r = appel(corps(catalogue["actifs"][0], **{interdits[0]: True}))
    assert r.status_code == 400
    assert code_erreur(r) == "parameter_not_allowed"


def test_outil_heberge_refuse(appel, catalogue):
    if not catalogue["actifs"]:
        pytest.skip("aucun alias actif")
    r = appel(corps(catalogue["actifs"][0], tools=[{"type": "web_search"}]))
    assert r.status_code == 400
    assert code_erreur(r) == "tool_not_allowed"


# --- Corrélation (OBS-01)

def test_traceparent_propage(appel):
    trace_id = uuid.uuid4().hex
    r = appel(corps("modele-inexistant"), entetes={"traceparent": f"00-{trace_id}-{uuid.uuid4().hex[:16]}-01"})
    assert r.headers.get("x-trace-id") == trace_id
    assert r.json()["error"]["trace_id"] == trace_id


# --- Appel nominal, alias masquant le déploiement (MGW-01, MGW-07)

def test_appel_nominal(appel, catalogue):
    if not catalogue["actifs"]:
        pytest.skip("aucun alias actif")
    alias = catalogue["actifs"][0]
    r = appel(corps(alias))
    assert r.status_code == 200, r.text
    assert r.json()["model"] == alias
    for entete in ("x-ms-region", "x-ms-deployment-name"):
        assert entete not in r.headers


# --- PO-12 : streaming sans mise en tampon (MGW-06)

def test_streaming_sans_tampon(appel, catalogue):
    if not catalogue["actifs"]:
        pytest.skip("aucun alias actif")
    debut = time.monotonic()
    r = appel(corps(catalogue["actifs"][0], stream=True, input="Compte de 1 à 200, un nombre par ligne.", max_output_tokens=800), stream=True)
    assert r.status_code == 200
    premier = None
    for ligne in r.iter_lines():
        if ligne and premier is None:
            premier = time.monotonic() - debut
    total = time.monotonic() - debut
    assert premier is not None and premier < total * 0.8, f"premier octet {premier:.1f}s pour {total:.1f}s : flux mis en tampon ?"


# --- PO-13 : un appel direct à Foundry est refusé (critère de sortie V1)

def test_foundry_refuse_appel_direct(catalogue):
    jeton = az("account", "get-access-token", "--resource", "https://cognitiveservices.azure.com", "--query", "accessToken")
    url = f'https://aif-{catalogue["base"]}.openai.azure.com/openai/v1/responses'
    r = requests.post(url, json={"model": "x", "input": "x"}, headers={"Authorization": f"Bearer {jeton}"}, timeout=60)
    assert r.status_code in (401, 403), r.status_code
    r = requests.post(url, json={"model": "x", "input": "x"}, headers={"api-key": "cle-quelconque"}, timeout=60)
    assert r.status_code in (401, 403), r.status_code


# --- FIN-01 : l'événement d'usage arrive dans Log Analytics

def test_evenement_usage_enregistre(appel, catalogue):
    trace_id = uuid.uuid4().hex
    appel(corps("modele-inexistant"), entetes={"traceparent": f"00-{trace_id}-{uuid.uuid4().hex[:16]}-01"})
    espace = az("monitor", "log-analytics", "workspace", "show", "-g", f'rg-{catalogue["base"]}',
                "-n", f'log-{catalogue["base"]}', "--query", "customerId")
    requete = f"UsageEvents | where trace_id == '{trace_id}' | project application_id, http_status, user_id, company_id"
    for _ in range(30):  # délai d'ingestion : jusqu'à 15 minutes
        res = az("monitor", "log-analytics", "query", "-w", espace, "--analytics-query", requete, "--query", "[0].application_id")
        if res:
            assert res == "opencode"
            return
        time.sleep(30)
    pytest.fail("événement d'usage absent après 15 minutes")


# --- PO-11 : limite d'appels par abonnement en Consumption (MGW-03)

@pytest.mark.skipif(os.environ.get("RUN_RATE_LIMIT_TEST", "false").lower() != "true", reason="RUN_RATE_LIMIT_TEST")
def test_limite_appels(appel, catalogue):
    if not catalogue["actifs"]:
        pytest.skip("aucun alias actif")
    limite = catalogue["app"]["limits"]["calls_per_minute"]
    # Appels valides sur l'alias le moins cher : un appel refusé (400) fausserait l'alerte de taux d'erreur (OBS-07).
    alias = min(catalogue["modeles"], key=lambda a: catalogue["modeles"][a]["pricing"]["input"])
    # Vagues parallèles, arrêt au premier 429 : le nombre de 429 produits reste sous le seuil
    # de l'alerte « limites-429 » du catalogue, le test ne déclenche donc pas de notification.
    vague = max(1, min(32, catalogue["envcat"]["alerting"]["throttled_calls_max"] // 2))
    # En Consumption, le compteur est réparti entre nœuds et approximatif (environ +25 % mesuré, PO-11) :
    # jusqu'à 2,5 fois la limite.
    codes = []
    with ThreadPoolExecutor(max_workers=vague) as pool:
        while 429 not in codes and len(codes) < limite * 2.5:
            codes += list(pool.map(lambda _: appel(corps(alias)).status_code, range(vague)))
    assert 429 in codes, f"aucune réponse 429 après {len(codes)} appels (limite {limite}/min)"
    assert set(codes) <= {200, 429}, f"codes inattendus : {sorted(set(codes))}"
    r = appel(corps(alias))
    if r.status_code == 429:
        assert code_erreur(r) == "rate_limited" and "Retry-After" in r.headers
