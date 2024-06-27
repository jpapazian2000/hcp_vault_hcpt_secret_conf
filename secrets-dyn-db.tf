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
  default_ttl = 60
  max_ttl = 120
}