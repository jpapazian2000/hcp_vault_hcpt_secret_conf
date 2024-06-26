#create kv  and populate it
# Mount a new KV v2 secrets engine at kv-customer-info/ in the us-west-org namespace
resource "vault_mount" "dw_kv" {
   path        = "dw_kv-customer-info"
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


#create encryption key /transit

#certificate management

#snow integration

#policies to access the secrets