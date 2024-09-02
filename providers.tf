terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.2.0"
    }
  }
}
#data "tfe_outputs" "vault_infra" {
   #organization = "jpapazian-org"
   #workspace = "hcp_vault_hcpt_infra"
#} 
data "tfe_outputs" "vault_ns" {
   organization = "jpapazian-org"
   workspace = "hcp_vault_hcpt_ns_conf"
}

provider "vault" {
    #address = data.tfe_outputs.vault_infra.values.vault_public_url
    address = var.vault_public_url
    auth_login_userpass {
      namespace = "admin/sanofi/${data.tfe_outputs.vault_ns.values.it_namespace}"
      #namespace = "admin/dw"
      username = var.ns_admin_user
      password = var.ns_admin_password
  }
}
