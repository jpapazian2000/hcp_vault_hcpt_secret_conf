resource "vault_policy" "dw_kv_policy" {
   name       = "kv_customer-info_ro_policy"
   namespace  = vault_namespace.dw_ns.path
   policy     = <<EOF
path "${vault_mount.dw_kv.path}/*" {
   capabilities = ["read"]
}
EOF
}

resource "vault_generic_endpoint" "kv_read_user" {
  namespace  = vault_namespace.dw_ns.path  
  depends_on           = [vault_auth_backend.userpass]
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