output "kv_secret" {
    value = vault_kv_secret_v2.customer.name
}
output "dw_namespace" {
    value = data.tfe_outputs.vault_ns.values.dw_namespace
    sensitive = true
}
output "vault_pki_secret_backend_root_cert_dw-root-cert" {
  value = vault_pki_secret_backend_root_cert.dw_root.certificate
}