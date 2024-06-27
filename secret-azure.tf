#create db secret and request dynamic secrets with azure 
resource "vault_azure_secret_backend" "sanofi_azure" {
  use_microsoft_graph_api = true
  subscription_id = var.az_subscription_id
  tenant_id = var.az_tenant_id
  client_id = var.az_client_id
  client_secret = var.az_client_secret
  path = sanofi_azure
}
resource "vault_azure_secret_backend_role" "generated_role" {
  backend                     = vault_azure_secret_backend.sanofi_azure.path
  role                        = "sanofi_azure_role"
  ttl = 120
  max_ttl = 180
  azure_roles {
    role_name = "Contributor"
    scope =  "/subscriptions/${var.az_subscription_id}/resourceGroups/azure-vault-sanofi-rg"
  }
}