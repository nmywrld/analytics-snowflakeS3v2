// Snowflake DDL
resource "snowflake_database" "db" {
  name    = upper("${var.project_code}_${var.region_code}_raw_db_${terraform.workspace}")
  comment = "Database for Snowflake Ingestion Pipeline (awssnowpipe) project"  
}

resource "snowflake_schema" "schema" {    
  database = snowflake_database.db.name
  name     = "TEST"
  comment  = "Schema from TEST source system"

  is_transient        = false
  is_managed          = false
}