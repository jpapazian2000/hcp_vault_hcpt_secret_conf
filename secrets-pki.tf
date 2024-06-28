resource "vault_mount" "pki" {
  path                      = "dw_pki"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_config_urls" "dw_sanofi_backend_urls" {
  backend = vault_mount.pki.path
  issuing_certificates = [
    "${data.tfe_outputs.vault_infra.values.vault_public_url}/v1/${vault_mount.pki.path}/ca",
  ]
  crl_distribution_points = [ 
    "${data.tfe_outputs.vault_infra.values.vault_public_url}/v1/${vault_mount.pki.path}/crl"
   ]
}

resource "vault_pki_secret_backend_root_cert" "dw_root" {
  backend = vault_mount.pki.path
  type = "internal"
  common_name = "dw.sanofi.com"
  ttl = "315360000"
  issuer_name = "dw-root-cert"
}

resource "vault_pki_secret_backend_role" "dw_role" {
  backend          = vault_mount.pki.path
  name             = "dw_role"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["dw.sanofi.com"]
  allow_subdomains = true
}