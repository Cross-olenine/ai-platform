# CAT-04 : un catalogue incomplet (GUID nul) est refusé ; le catalogue de test est accepté.

run "catalogue_de_test_accepte" {
  command = plan
  variables {
    catalog_path = "../../tests/fixtures/catalog"
    environment  = "dev"
  }
  assert {
    condition     = length(output.models) == 3 && output.name.resource_group == "rg-aiplat-dev-frc-01"
    error_message = "Les trois alias actifs (deux chats, un embedding) et la convention de nommage sont attendus."
  }
  assert {
    condition     = output.models["embedding-default"].kind == "embedding" && output.models["agent-fast"].kind == "chat" && output.models["embedding-default"].pricing.output == 0
    error_message = "ADR-19 : kind vaut chat par défaut ; un embedding n'a pas de tarif de sortie."
  }
  assert {
    condition     = output.tags["environment"] == "dev" && output.tags["managed-by"] == "terraform"
    error_message = "Tags obligatoires attendus (FIN-05)."
  }
}

run "catalogue_incomplet_refuse" {
  command = plan
  variables {
    catalog_path = "../../tests/fixtures/catalogue-incomplet"
    environment  = "dev"
  }
  expect_failures = [terraform_data.checks]
}
