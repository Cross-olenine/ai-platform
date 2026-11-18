#!/usr/bin/env bash
# Enchaîne les 3 états Terraform d'un environnement, dans l'ordre (socle -> observabilite -> passerelle-modeles).
# Usage : scripts/ci/terraform-etats.sh <dev|prod> <plan|apply|drift>
#   plan  : plan de chaque état (un état non encore créé peut empêcher le plan du suivant au premier déploiement)
#   apply : plan puis application, état par état
#   drift : plan sans application ; code de sortie 2 si une dérive est détectée
# Variables attendues (pipelines) : ARM_CLIENT_ID, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID, ARM_USE_OIDC=true,
#   TFSTATE_RESOURCE_GROUP, TFSTATE_STORAGE_ACCOUNT, TF_VAR_gateway_api_client_id.
set -euo pipefail

env="${1:?environnement (dev|prod)}"
mode="${2:?mode (plan|apply|drift)}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
drift=0

for etat in socle observabilite passerelle-modeles; do
  dir="$root/terraform/environments/$env/$etat"
  echo "::group::$env / $etat : $mode"
  terraform -chdir="$dir" init -input=false \
    -backend-config="resource_group_name=${TFSTATE_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${TFSTATE_STORAGE_ACCOUNT}"
  set +e
  terraform -chdir="$dir" plan -input=false -detailed-exitcode -out=tfplan
  code=$?
  set -e
  if [ "$code" -eq 1 ]; then echo "::error::plan en échec ($env/$etat)"; exit 1; fi
  if [ "$code" -eq 2 ]; then drift=1; fi
  terraform -chdir="$dir" show -no-color tfplan > "$dir/tfplan.txt"
  if [ "$mode" = "apply" ] && [ "$code" -eq 2 ]; then
    terraform -chdir="$dir" apply -input=false tfplan
  fi
  echo "::endgroup::"
done

if [ "$mode" = "drift" ] && [ "$drift" -eq 1 ]; then
  echo "::warning::dérive détectée sur $env : à corriger dans le code (docs/pratiques/devops-genaiops.md)"
  exit 2
fi
