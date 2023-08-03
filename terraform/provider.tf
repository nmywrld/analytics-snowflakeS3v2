provider "aws" {
  shared_credentials_files = ["../.auth/credentials"]
  shared_config_files      = ["../.auth/config"]
  profile                  = "default"
}


provider "snowflake" {
  account          = var.snowflake_account_param["account"]  
  region           = var.snowflake_account_param["region"]
  username         = var.snowflake_account_param["user"]
  role             = var.snowflake_account_param["role"]
  password         = var.snowflake_account_param["password"]
}