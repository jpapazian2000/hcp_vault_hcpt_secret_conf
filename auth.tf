resource "vault_policy" "dw_kv_policy" {
   name       = "kv_customer-info_ro_policy"
   policy     = <<EOF
path "${vault_mount.dw_kv.path}/*" {
   capabilities = ["read"]
}
EOF
}

resource "vault_generic_endpoint" "kv_read_user" {
  #depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/kv_user"
  ignore_absent_fields = true
  #write_fields         = ["id"]

  data_json = <<EOT
{
  "policies": ["kv_customer-info_ro_policy"],
  "password": "changeme"
}
EOT
}

resource "vault_policy" "dw_dw_db_policy" {
   name       = "dw_postgres_ro_policy"
   policy     = <<EOF
path "${vault_database_secrets_mount.dw_db.path}/creds/readonly" {
   capabilities = ["read"]
}
EOF
}

resource "vault_generic_endpoint" "postgres_read_user" {
  #depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/pg_user"
  ignore_absent_fields = true
  #write_fields         = ["id"]

  data_json = <<EOT
{
  "policies": ["dw_postgres_ro_policy"],
  "password": "changeme"
}
EOT
}