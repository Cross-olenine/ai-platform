#!/usr/bin/env bash
# Les racines dev et prod doivent être identiques au nom d'environnement près (seuls les paramètres
# du catalogue varient entre environnements, docs/pratiques/devops-genaiops.md).
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)/terraform/environments"
for etat in socle observabilite passerelle-modeles; do
  if ! diff <(sed -e 's/\bdev\b/ENV/g; s/\bDEV\b/ENV/g' "$root/dev/$etat/main.tf") \
            <(sed -e 's/\bprod\b/ENV/g; s/\bPROD\b/ENV/g' "$root/prod/$etat/main.tf") >/dev/null; then
    echo "::error::terraform/environments/{dev,prod}/$etat divergent."
    diff <(sed -e 's/\bdev\b/ENV/g; s/\bDEV\b/ENV/g' "$root/dev/$etat/main.tf") <(sed -e 's/\bprod\b/ENV/g; s/\bPROD\b/ENV/g' "$root/prod/$etat/main.tf") || true
    exit 1
  fi
done
echo "Racines dev et prod identiques."
