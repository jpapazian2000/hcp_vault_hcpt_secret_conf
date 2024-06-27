resource "vault_mount" "transit" {
  path                      = "sanofi-eaas"
  type                      = "transit"
  description               = "generate keys to encrypt/decrypt data"
  default_lease_ttl_seconds = 120
  max_lease_ttl_seconds     = 180
}

resource "vault_transit_secret_backend_key" "key" {
  backend = vault_mount.transit.path
  name    = "dw-sanofi_eaas"
  deletion_allowed = true
}
resource "vault_policy" "dw_eaas-encrypt-decrypt_policy" {
   name       = "dw_eaas-encrypt-decrypt_policy"
   policy     = <<EOF
path "${vault_mount.transit.path}/encrypt/${vault_transit_secret_backend_key.key.name}" {
   capabilities = ["update"]
}
path "${vault_mount.transit.path}/decrypt/${vault_transit_secret_backend_key.key.name}" {
   capabilities = ["update"]
}
EOF
}

resource "vault_generic_endpoint" "sanofi_eaas_crypto-user" {
  #depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${var.sanofi-crypto_user}"
  ignore_absent_fields = true
  #write_fields         = ["id"]

  data_json = <<EOT
{
  "policies": ["dw_eaas-encrypt-decrypt_policy"],
  "password": "${var.sanofi-crypto_user}"
}
EOT
}
