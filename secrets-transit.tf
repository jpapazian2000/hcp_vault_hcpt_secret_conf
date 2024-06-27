resource "vault_mount" "transit" {
  path                      = "sanofi-eaas"
  type                      = "transit"
  description               = "generate keys to encrypt/decrypt data"
  default_lease_ttl_seconds = 120
  max_lease_ttl_seconds     = 180
}

resource "vault_transit_secret_backend_key" "key" {
  backend = vault_mount.transit.path
  name    = "sanofi_eaas"
}