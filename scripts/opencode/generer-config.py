#!/usr/bin/env python3
"""CHN-07 : génère la configuration centrale d'OpenCode depuis les catalogues (aucune valeur saisie à la main).

Écrit adapters/opencode/<env>/opencode.json pour chaque environnement du catalogue.
La CI régénère les fichiers et échoue s'ils diffèrent de ceux du dépôt (pr.yml).
Le jeton Entra ID et la clé d'abonnement sont lus dans l'environnement (scripts/opencode/aiplat-env.sh),
jamais écrits dans le fichier (KV-02, KV-03).
"""
import json
from pathlib import Path

import yaml

RACINE = Path(__file__).resolve().parents[2]
CATALOGUE = RACINE / "catalog"
SORTIE = RACINE / "adapters" / "opencode"
APPLICATION = "opencode"
FOURNISSEUR = "aiplat"


def charger(chemin: Path):
    return yaml.safe_load(chemin.read_text(encoding="utf-8"))


def main() -> None:
    commun = charger(CATALOGUE / "environments" / "commun.yaml")
    modeles = {m["alias"]: m for m in (charger(f) for f in sorted((CATALOGUE / "models").glob("*.yaml")))}
    plateforme = commun["platform"]

    for fichier in sorted((CATALOGUE / "environments").glob("*.yaml")):
        if fichier.name == "commun.yaml":
            continue
        env = charger(fichier)
        app = next((a for a in env["applications"] if a["id"] == APPLICATION), None)
        if app is None:
            continue
        base = f'{plateforme["prefix"]}-{env["name"]}-{plateforme["location_short"]}-{env["name_suffix"]}'
        alias = [a for a in app["allowed_models"] if a in modeles]

        config = {
            "$schema": "https://opencode.ai/config.json",
            "providers": {
                FOURNISSEUR: {
                    "name": f"Plateforme IA ({env['name']})",
                    # Jeton Entra ID envoyé en « Authorization: Bearer » (IAM-01).
                    "env": ["AIPLAT_TOKEN"],
                    "package": "@opencode/ai/providers/openai-compatible/responses",  # ADR-06
                    "settings": {"baseURL": f"https://apim-{base}.azure-api.net/model-gateway/v1"},
                    "headers": {
                        # ADR-18 : la clé identifie l'application pour les limites ; elle n'authentifie pas.
                        "Ocp-Apim-Subscription-Key": "{env:AIPLAT_SUBSCRIPTION_KEY}",
                    },
                    "models": {
                        a: {
                            "name": a,
                            "limit": {
                                "context": modeles[a].get("context_window", 0),
                                "output": modeles[a]["max_output_tokens"],  # MGW-05 : plafond de la passerelle
                            },
                        }
                        for a in alias
                    },
                }
            },
            "model": f"{FOURNISSEUR}/{alias[0]}" if alias else None,
            "share": "disabled",
            # Seule la passerelle est utilisable (règle 6) ; à valider sur la version d'OpenCode déployée (PO-14).
            "policies": [
                {"action": "provider.use", "resource": "*", "effect": "deny"},
                {"action": "provider.use", "resource": FOURNISSEUR, "effect": "allow"},
            ],
        }
        config = {k: v for k, v in config.items() if v is not None}

        cible = SORTIE / env["name"] / "opencode.json"
        cible.parent.mkdir(parents=True, exist_ok=True)
        cible.write_text(json.dumps(config, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"écrit : {cible.relative_to(RACINE)}")


if __name__ == "__main__":
    main()
