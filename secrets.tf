#create kv  and populate it
# Mount a new KV v2 secrets engine at kv-customer-info/ in the us-west-org namespace
resource "vault_mount" "dw_kv" {
   path        = "customer-info"
   type        = "kv-v2"
}
# Create test data at customer-info/customer-001
resource "vault_kv_secret_v2" "customer" {
   depends_on  = [vault_mount.dw_kv]
   mount                      = vault_mount.dw_kv.path
   name                       = "customer_important"
   delete_all_versions        = true
   data_json                  = jsonencode(
   {
      name          = "Example LLC",
      contact_email = "admin@example.com"
   }
   )
}
#create dynamic db with postgresql
resource "vault_database_secrets_mount" "dw_db" {
  path = "dw_db"
  postgresql {
    name              = "dw_db"
    username          = var.postgres_db_user
    password          = var.postgres_db_password
    connection_url    = "postgresql://{{username}}:{{password}}@${var.POSTGRES_URL}/postgres?sslmode=disable"
    verify_connection = true
    allowed_roles = [
      "dw_role",
    ]
  }
}
resource "vault_database_secret_backend_role" "dw_role" {
  name    = "dw_role"
  backend = vault_database_secrets_mount.dw_db.path
  db_name = vault_database_secrets_mount.dw_db.postgresql[0].name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
  ]
}

#create db secret and request dynamic secrets

#create encryption key /transit

#certificate management

#snow integration

#policies to access the secrets