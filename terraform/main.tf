
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.24.0"
    }
    
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.55.0"
    }
  }   
  required_version = ">= 1.1"
}

locals {
  prefix       = "${var.project_code}-${var.region_code}"
  bucket_name  = "${local.prefix}-snowflake-load-${terraform.workspace}"
  default_tags = {
    Project   = upper(var.project_code)
    ManagedBy = var.managed_by
  }
  prefix_mapping = jsondecode(file("../assets/prefix_mapping.json"))

}


