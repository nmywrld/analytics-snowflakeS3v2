
#Create an encrypted bucket and restrict access from public

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket" "stage_bucket_load" {
  bucket = local.bucket_name


  lifecycle {
    ignore_changes = [ server_side_encryption_configuration ]
  }

  tags = local.default_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
    depends_on = [aws_s3_bucket_ownership_controls.this]


  bucket = aws_s3_bucket.stage_bucket_load.id
  acl    = "private"
}

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

