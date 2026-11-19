"""Configuration des tests de la passerelle (API-05).

Les valeurs sont dérivées du catalogue et de la session Azure CLI ; rien n'est saisi en dur.
Variables : AIPLAT_ENV (dev|prod), GATEWAY_API_CLIENT_ID (sinon recherche par nom), RUN_RATE_LIMIT_TEST.
"""
import json
import os
import subprocess
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
        "actifs": [m["alias"] for m in modeles if m["status"] == "active"],
        "modeles": {m["alias"]: m for m in modeles if m["status"] == "active"},
        "app": next(a for a in envcat["applications"] if a["id"] == "opencode"),
    }


@pytest.fixture(scope="session")
def url(catalogue):
    return f'https://apim-{catalogue["base"]}.azure-api.net/model-gateway/v1/responses'


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
    def _appel(corps, entetes=None, jeton_=None, cle_=None, **kw):
        h = {"Content-Type": "application/json"}
        if (jeton_ if jeton_ is not None else jeton):
            h["Authorization"] = f"Bearer {jeton_ if jeton_ is not None else jeton}"
        if (cle_ if cle_ is not None else cle):
            h["Ocp-Apim-Subscription-Key"] = cle_ if cle_ is not None else cle
        h.update(entetes or {})
        return requests.post(url, data=json.dumps(corps), headers=h, timeout=120, **kw)
    return _appel
