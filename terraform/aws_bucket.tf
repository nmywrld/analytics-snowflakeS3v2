
#Create an encrypted bucket and restrict access from public

# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }


resource "aws_s3_bucket" "stage_bucket_load" {
  bucket = local.bucket_name
  force_destroy = true


  lifecycle {
    ignore_changes = [ server_side_encryption_configuration ]
  }

  tags = local.default_tags
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.stage_bucket_load.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.stage_bucket_load.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "this" {
#     depends_on = [aws_s3_bucket_ownership_controls.this]


#   bucket = aws_s3_bucket.stage_bucket_load.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "stage_bucket_load_access_block" {
  bucket = aws_s3_bucket.stage_bucket_load.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# https://spacelift.io/blog/terraform-for-loop
# resource "aws_s3_object" "object" {
#   bucket = aws_s3_bucket.stage_bucket_load.id
#   key    = "x/"
# }

resource "aws_s3_object" "prefix_create" {
  count = "${length(local.prefix_mapping)}"
  # bucket = local.bucket_name
  bucket = aws_s3_bucket.stage_bucket_load.id
  key = "${element(keys(local.prefix_mapping), count.index)}/" # lookup the key name based on the current count index.
  # content = "${lookup(var.object_list, "${element(keys(var.object_list), count.index)}")}" # lookup the key's value based on a double interpolation.
}

