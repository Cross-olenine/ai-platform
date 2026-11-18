# CAT-04 : un catalogue incomplet (GUID nul) est refusé ; le catalogue de test est accepté.

run "catalogue_de_test_accepte" {
  command = plan
  variables {
    catalog_path = "../../tests/fixtures/catalog"
    environment  = "dev"
  }
  assert {
    condition     = length(output.models) == 2 && output.name.resource_group == "rg-aiplat-dev-frc-01"
    error_message = "Les deux alias actifs et la convention de nommage sont attendus."
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
