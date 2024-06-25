variable "dw_admin_user" {
  description = "user who will manage vault"
}
variable "dw_admin_password" {
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