output "s3_bucket_url"{
  value = "s3://${local.bucket_name}/"
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.stage_bucket_load.arn
}

output "s3_bucket_id" {
  value = aws_s3_bucket.stage_bucket_load.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.snowflake_load_bucket_topic.arn
}

output "snowflake_role_arn" {
  value = aws_iam_role.role_for_snowflake_load.arn
}


output "snowflake_storage_integration_id" {
  value  = snowflake_storage_integration.integration.id
}

output "storage_aws_external_id" {
  value  = snowflake_storage_integration.integration.storage_aws_external_id
}

output "storage_aws_iam_user_arn" {
  value  = snowflake_storage_integration.integration.storage_aws_iam_user_arn
}


output "snowflake_db" {
  value  = snowflake_database.db.name
}

output "snowflake_schema" {
  value  = snowflake_schema.schema.name
}

output "snowflake_stage" {
  value  = snowflake_stage.this.name
}

output "snowflake_stage_integration" {
  value  = snowflake_stage.this.storage_integration
}

