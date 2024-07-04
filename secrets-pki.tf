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
  common_name = "chc.sanofi.com"
  ttl = "315360000"
  issuer_name = "dw-root-cert"
}
resource "vault_pki_secret_backend_issuer" "dw_root" {
   backend                        = vault_mount.pki.path
   issuer_ref                     = vault_pki_secret_backend_root_cert.dw_root.issuer_id
   issuer_name                    = vault_pki_secret_backend_root_cert.dw_root.issuer_name
   revocation_signature_algorithm = "SHA256WithRSA"
}

resource "vault_pki_secret_backend_role" "dw_role" {
  backend          = vault_mount.pki.path
  name             = "dw_role"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["chc.sanofi.com"]
  allow_subdomains = true
}
#create an intermediate authority
resource "vault_mount" "dw_pki_int" {
   path        = "dw_pki_int"
   type        = "pki"
   description = "This is an example intermediate PKI mount"

   default_lease_ttl_seconds = 86400
   max_lease_ttl_seconds     = 157680000
}
resource "vault_pki_secret_backend_intermediate_cert_request" "dw_csr-request" {
   backend     = vault_mount.dw_pki_int.path
   type        = "internal"
   common_name = "chc.sanofi.com Intermediate Authority"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "dw_intermediate" {
   backend     = vault_mount.pki.path
   common_name = "new_intermediate"
   csr         = vault_pki_secret_backend_intermediate_cert_request.dw_csr-request.csr
   format      = "pem_bundle"
   ttl         = 15480000
   issuer_ref  = vault_pki_secret_backend_root_cert.dw_root.issuer_id
}
resource "vault_pki_secret_backend_intermediate_set_signed" "dw_intermediate" {
   backend     = vault_mount.dw_pki_int.path
   certificate = vault_pki_secret_backend_root_sign_intermediate.dw_intermediate.certificate
}
resource "vault_pki_secret_backend_issuer" "dw_intermediate" {
  backend     = vault_mount.dw_pki_int.path
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.dw_intermediate.imported_issuers[0]
  issuer_name = "dw-dot-com-intermediate"
}
resource "vault_pki_secret_backend_role" "dw_intermediate_role" {
   backend          = vault_mount.dw_pki_int.path
   issuer_ref       = vault_pki_secret_backend_issuer.dw_intermediate.issuer_ref
   name             = "dw_intermediate-role"
   ttl              = 86400
   max_ttl          = 2592000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["chc.sanofi.com"]
   allow_subdomains = true
}

resource "vault_policy" "dw_pki-int_policy" {
   name       = "dw_pki-int_policy"
   policy     = <<EOF
   path "${vault_mount.dw_pki_int.path}/issue/${vault_pki_secret_backend_role.dw_intermediate_role.name}" {
   capabilities = ["read"]
}
EOF
}
resource "vault_generic_endpoint" "pki_int_user" {
  #depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${var.pki-int_user}"
  ignore_absent_fields = true
  #write_fields         = ["id"]

  data_json = <<EOT
{
  "policies": ["dw_pki-int_policy"],
  "password": "${var.pki-int_user}"
}
EOT
}