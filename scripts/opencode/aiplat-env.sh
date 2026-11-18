#!/usr/bin/env bash
# Prépare l'environnement d'OpenCode pour la passerelle de la plateforme IA (CHN-02, PO-14).
# Usage : source scripts/opencode/aiplat-env.sh <dev|prod>
# Prérequis : « az login » avec un compte qui a le rôle « utilisateur » sur l'API passerelle (IAM-03)
#             et le droit de lire la clé d'abonnement de l'application opencode (key_readers du catalogue).
# Développement spécifique (mode D) justifié : OpenCode ne sait pas obtenir lui-même un jeton Entra ID.
# Le jeton expire (environ 1 h) : relancer ce script puis OpenCode si la passerelle renvoie 401.

_aiplat_env="${1:-dev}"
_aiplat_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
_aiplat_base="$(python3 - "$_aiplat_root" "$_aiplat_env" <<'PY'
import sys, yaml, pathlib
root, env = pathlib.Path(sys.argv[1]), sys.argv[2]
c = yaml.safe_load((root / "catalog/environments/commun.yaml").read_text())["platform"]
e = yaml.safe_load((root / f"catalog/environments/{env}.yaml").read_text())
print(f'{c["prefix"]}-{env}-{c["location_short"]}-{e["name_suffix"]}')
PY
)"

_aiplat_api_id="$(az ad app list --display-name "${_aiplat_base%%-*}-${_aiplat_env}-gateway-api" --query '[0].appId' -o tsv)"
if [ -z "$_aiplat_api_id" ]; then
  echo "Application « API passerelle » introuvable : vérifier az login et le bootstrap." >&2
  return 1 2>/dev/null || exit 1
fi

AIPLAT_TOKEN="$(az account get-access-token --resource "api://${_aiplat_api_id}" --query accessToken -o tsv)" || return 1
AIPLAT_SUBSCRIPTION_KEY="$(az keyvault secret show --vault-name "kv-${_aiplat_base}" --name apim-subscription-key-opencode --query value -o tsv)" || return 1
export AIPLAT_TOKEN AIPLAT_SUBSCRIPTION_KEY
echo "Jeton et clé chargés pour la passerelle ${_aiplat_env}."
echo "Configuration centrale : ${_aiplat_root}/adapters/opencode/${_aiplat_env}/opencode.json"
echo "(postes gérés : copiée dans /etc/opencode/, prioritaire sur la configuration de l'utilisateur ; voir adapters/opencode/README.md)."
unset _aiplat_env _aiplat_root _aiplat_base _aiplat_api_id
