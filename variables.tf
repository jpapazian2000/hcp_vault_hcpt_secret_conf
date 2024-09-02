variable "vault_public_url" {
  description = "vault public url"
}

variable "ns_admin_user" {
  description = "user who will manage vault"
}
variable "ns_admin_password" {
  description = "password for the admin user"
}
variable "POSTGRES_URL" {
  description = "url provided by ngrok when connecting to local postgres"
}
variable "postgres_db_user"{
  description= "user configured in postgres db"
}

variable "postgres_db_password" {
  description = "password for posgres user"
}

variable "postgres_user"{
  description= "user to connect to postgres"
}
variable "postgres_password"{
  description= "password for user configured in postgres db"
}
variable "az_tenant_id" {
  description = "azure tenant id"
}
variable "az_client_id" {
  description = "azure application(client) id"
}
variable "az_client_secret" {
  description = "azure client secret (NOT secret_id) of the key of the app"
}
variable "az_subscription_id" {
  description = "subscription_id of the azure tenant"
}
variable "az-ro_user" {
  description = "azure user read only"
}
 variable "customer-crypto_user" {
  description = "user for encryption and decryption"
 }
 variable "pki-int_user" {
  description = "user for generating certs"
 }
