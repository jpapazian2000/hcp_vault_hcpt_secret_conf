output "dw_namespace" {
    value = data.tfe_outputs.vault_ns.values.dw_namespace
    sensitive = true
}
output "dw_kv_secret" {
    value = vault_kv_secret_v2.customer.name
}
output "dw_db_secret" {
    value = vault_database_secrets_mount.dw_db.path
}
output "dw_azure_secret" {
    value = vault_azure_secret_backend.sanofi_azure.path
}
output "dw_eaas_secret" {
    value = vault_mount.transit.path
}
output "dw_pki_secret" {
    value = vault_mount.pki.path
}
output "vault_pki_secret_backend_root_cert_dw-root-cert" {
  value = vault_pki_secret_backend_root_cert.dw_root.certificate
}