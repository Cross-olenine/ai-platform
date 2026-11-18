#!/usr/bin/env bash
# Modèle de branches (docs/pratiques/devops-genaiops.md) :
#  - en demande de changement : la branche source est la branche attendue (develop -> test -> preprod -> main) ;
#  - après fusion : l'arbre promu est identique à celui de la branche source (même code à chaque étape).
# Usage : verifier-promotion.sh pr <branche cible> <branche source>
#         verifier-promotion.sh merge
set -euo pipefail

attendu() {
  case "$1" in
    test) echo develop ;;
    preprod) echo test ;;
    main) echo preprod ;;
    *) echo "" ;;
  esac
}

case "${1:?mode}" in
  pr)
    cible="$2"; source="$3"; requis="$(attendu "$cible")"
    if [ -n "$requis" ] && [ "$source" != "$requis" ]; then
      echo "::error::$cible n'accepte que les demandes de changement depuis $requis (reçu : $source)."
      exit 1
    fi
    echo "Promotion $source -> $cible conforme."
    ;;
  merge)
    if ! git rev-parse -q --verify HEAD^2 >/dev/null; then
      echo "::error::le commit poussé n'est pas une fusion : modification directe interdite sur cette branche."
      exit 1
    fi
    if [ "$(git rev-parse 'HEAD^{tree}')" != "$(git rev-parse 'HEAD^2^{tree}')" ]; then
      echo "::error::l'arbre promu diffère de celui de la branche source (conflit ou modification pendant la fusion)."
      exit 1
    fi
    echo "Arbre promu identique à la source : $(git rev-parse 'HEAD^{tree}')"
    ;;
esac
