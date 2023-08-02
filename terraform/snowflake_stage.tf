##  create a custom stage for prefix: '/data'

resource "snowflake_file_format" "this" {
  name        = "jsonFormat"
  database    = snowflake_database.db.name
  schema      = snowflake_schema.schema.name
  format_type = "JSON"
  compression = "gzip"
  binary_format = "HEX"
}


resource "snowflake_stage" "this" {
  name                = upper("${var.project_code}_${var.region_code}_json_load_stage_${terraform.workspace}")
  url                 = "s3://${local.bucket_name}/"
  database            = snowflake_database.db.name
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.integration.name
  
  # file_format         = snowflake_file_format.this.name
  # file_format         = "FORMAT_NAME = ${snowflake_file_format.this.name}" 
  # file_format         = "FORMAT_NAME = ${snowflake_database.db.name}.${snowflake_schema.schema.name}.${snowflake_file_format.this.name}" 
  file_format         = "TYPE = JSON NULL_IF = []"
  
  # snowflake_file_format.this.name
}

## create a custom stage for each table in mappings (likely stored in ./assets)
## check if a stage can handle different number of rows 
    ## i dont want to create too many stages, if possible. should be 1 stage
    ## based on prefix, we transform accordingly