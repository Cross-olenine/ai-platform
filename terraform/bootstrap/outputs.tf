output "tfstate_storage_account" {
  value = azurerm_storage_account.tfstate.name
}

output "tfstate_resource_group" {
  value = azurerm_resource_group.tfstate.name
}

output "resource_groups" {
  value = { for k, rg in azurerm_resource_group.env : k => rg.name }
}

output "pipeline_client_ids" {
  value = { for k, a in azuread_application.pipeline : k => a.client_id }
}

output "gateway_api_client_ids" {
  value = { for k, a in azuread_application.gateway_api : k => a.client_id }
}

output "repository_clone_url" {
  value = github_repository.platform.http_clone_url
}
