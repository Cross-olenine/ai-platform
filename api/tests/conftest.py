"""Configuration des tests de la passerelle (API-05).

Les valeurs sont dérivées du catalogue et de la session Azure CLI ; rien n'est saisi en dur.
Variables : AIPLAT_ENV (dev|prod), GATEWAY_API_CLIENT_ID (sinon recherche par nom), RUN_RATE_LIMIT_TEST.
"""
import json
import os
import subprocess
import time
from pathlib import Path

import pytest
import requests
import yaml

RACINE = Path(__file__).resolve().parents[2]


def az(*args: str) -> str:
    return subprocess.run(["az", *args, "-o", "tsv"], check=True, capture_output=True, text=True).stdout.strip()


@pytest.fixture(scope="session")
def catalogue():
    env = os.environ.get("AIPLAT_ENV", "dev")
    commun = yaml.safe_load((RACINE / "catalog/environments/commun.yaml").read_text())
    envcat = yaml.safe_load((RACINE / f"catalog/environments/{env}.yaml").read_text())
    modeles = [yaml.safe_load(f.read_text()) for f in sorted((RACINE / "catalog/models").glob("*.yaml"))]
    p = commun["platform"]
    base = f'{p["prefix"]}-{env}-{p["location_short"]}-{envcat["name_suffix"]}'
    return {
        "env": env,
        "base": base,
        "commun": commun,
        "envcat": envcat,
        # ADR-19 : « actifs » et « modeles » ne contiennent que les modèles de chat (route /responses).
        "actifs": [m["alias"] for m in modeles if m["status"] == "active" and m.get("kind", "chat") == "chat"],
        "modeles": {m["alias"]: m for m in modeles if m["status"] == "active" and m.get("kind", "chat") == "chat"},
        "embeddings": [m["alias"] for m in modeles if m["status"] == "active" and m.get("kind", "chat") == "embedding"],
        "app": next(a for a in envcat["applications"] if a["id"] == "opencode"),
    }


@pytest.fixture(scope="session")
def url(catalogue):
    return f'https://apim-{catalogue["base"]}.azure-api.net/model-gateway/v1/responses'


@pytest.fixture(scope="session")
def url_embeddings(url):
    return url.removesuffix("/responses") + "/embeddings"


@pytest.fixture(scope="session")
def audience(catalogue):
    client_id = os.environ.get("GATEWAY_API_CLIENT_ID") or az(
        "ad", "app", "list", "--display-name", f'{catalogue["commun"]["platform"]["prefix"]}-{catalogue["env"]}-gateway-api',
        "--query", "[0].appId")
    return f"api://{client_id}"


@pytest.fixture(scope="session")
def jeton(audience):
    return az("account", "get-access-token", "--resource", audience, "--query", "accessToken")


@pytest.fixture(scope="session")
def cle(catalogue):
    return az("keyvault", "secret", "show", "--vault-name", f'kv-{catalogue["base"]}',
              "--name", "apim-subscription-key-opencode", "--query", "value")


@pytest.fixture
def appel(url, jeton, cle):
    def _appel(corps, entetes=None, jeton_=None, cle_=None, url_=None, **kw):
        h = {"Content-Type": "application/json"}
        if (jeton_ if jeton_ is not None else jeton):
            h["Authorization"] = f"Bearer {jeton_ if jeton_ is not None else jeton}"
        if (cle_ if cle_ is not None else cle):
            h["Ocp-Apim-Subscription-Key"] = cle_ if cle_ is not None else cle
        h.update(entetes or {})
        return requests.post(url_ or url, data=json.dumps(corps), headers=h, timeout=120, **kw)
    return _appel


@pytest.fixture(scope="session", autouse=True)
def passerelle_prete(url, jeton, cle, catalogue):
    """Après la création de l'environnement, le droit d'accès de la passerelle à Foundry met plusieurs minutes
    à se propager (500 entre-temps). On attend un premier appel valide avant les tests, 10 minutes au plus."""
    if not catalogue["actifs"]:
        return
    entetes = {"Content-Type": "application/json", "Authorization": f"Bearer {jeton}", "Ocp-Apim-Subscription-Key": cle}
    corps = {"model": catalogue["actifs"][0], "input": "ok", "max_output_tokens": 16}
    fin = time.monotonic() + 600
    while True:
        try:
            if requests.post(url, data=json.dumps(corps), headers=entetes, timeout=60).status_code == 200:
                return
        except requests.RequestException:
            pass
        if time.monotonic() > fin:
            return  # les tests signaleront l'échec avec leur propre message
        time.sleep(20)
