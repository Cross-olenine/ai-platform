#!/usr/bin/env python3
"""FIN-05 : chaque ressource azurerm qui accepte des tags doit en recevoir dans le code.

Usage : verifier-tags.py <schema-providers.json> <dossier terraform>
Le schéma est produit par « terraform providers schema -json » depuis une racine initialisée.
"""
import json
import re
import sys
from pathlib import Path

schema = json.loads(Path(sys.argv[1]).read_text())
azurerm = next(v for k, v in schema["provider_schemas"].items() if k.endswith("hashicorp/azurerm"))
# Sous-ressources dont l'attribut « tags » n'est pas un tag Azure (étiquettes APIM, étiquettes de requête KQL).
NON_ARM = {"azurerm_log_analytics_saved_search"}
taggable = {
    name for name, r in azurerm["resource_schemas"].items()
    if r["block"].get("attributes", {}).get("tags", {}).get("type") == ["map", "string"] and name not in NON_ARM
}

bloc = re.compile(r'^resource\s+"(azurerm_[a-z0-9_]+)"\s+"([^"]+)"\s*\{(.*?)^\}', re.S | re.M)
erreurs = []
for tf in Path(sys.argv[2]).rglob("*.tf"):
    if ".terraform" in tf.parts:
        continue
    for m in bloc.finditer(tf.read_text()):
        rtype, nom, corps = m.groups()
        if rtype in taggable and not re.search(r"^\s*tags\s*=", corps, re.M):
            erreurs.append(f"{tf}: {rtype}.{nom} sans tags (FIN-05)")

print("\n".join(erreurs) or "Tags : toutes les ressources taggables reçoivent des tags.")
sys.exit(1 if erreurs else 0)
