##  create a custom stage for prefix: '/data'

resource "snowflake_stage" "stage_tweets" {
  name                = upper("${var.project_code}_${var.region_code}_tweets_load_stage_${terraform.workspace}")
  url                 = "s3://${local.bucket_name}/"
  database            = snowflake_database.db.name
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.integration.name
}

## create a custom stage for each table in mappings (likely stored in ./assets)
## check if a stage can handle different number of rows 
    ## i dont want to create too many stages, if possible. should be 1 stage
    ## based on prefix, we transform accordingly