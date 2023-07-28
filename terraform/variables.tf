
variable "aws_profile" {
  description = "Profile to use to authenticate to AWS"
  type        = string
}

variable "aws_region" {
  description = "Default region to use in AWS"
  type        = string  
}

variable "project_code" {
  description = "Project code to use as prefix for resources"
  type        = string
}

variable "region_code" {
  description = "Region short code to use as prefix for resources"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "managed_by" {
  description = "The owner of resource"
  type        = string
}

variable "snowflake_account_arn" {
  description = "Snowflake's account ARN"
  type        = string
}

variable "snowflake_external_id" {
  description = "Snowflake's external id"
  type        = string
}


variable "snowflake_account_param" {
  type = map(string)
  default = {
    account  = ""
    region   = ""
    role     = ""
    user     = ""
    password = ""
  }
}