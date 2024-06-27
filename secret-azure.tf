#create db secret and request dynamic secrets with azure 
resource "vault_azure_secret_backend" "sanofi_azure" {
  use_microsoft_graph_api = true
  subscription_id = var.az_subscription_id
  tenant_id = var.az_tenant_id
  client_id = var.az_client_id
  client_secret = var.az_client_secret
  path = "sanofi_azure"
}
resource "vault_azure_secret_backend_role" "sanofi_vault_azure_role" {
  backend                     = vault_azure_secret_backend.sanofi_azure.path
  role                        = "sanofi_azure_role"
  ttl = 120
  max_ttl = 180
  azure_roles {
    role_name = "Contributor"
    scope = "/subscriptions/${var.az_subscription_id}/resourceGroups/azure-vault-sanofi-rg"
  }
}

resource "vault_policy" "dw_azure-ro_policy" {
   name       = "dw_azure-ro_policy"
   policy     = <<EOF
path "${vault_azure_secret_backend.sanofi_azure.path}/creds/${vault_azure_secret_backend_role.sanofi_vault_azure_role.role}" {
   capabilities = ["read"]
}
EOF
}

resource "vault_generic_endpoint" "azure_read_user" {
  #depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${var.az-ro_user}"
  ignore_absent_fields = true
  #write_fields         = ["id"]

  data_json = <<EOT
{
  "policies": ["dw_azure-ro_policy"],
  "password": "${var.az-ro_user}"
}
EOT
}