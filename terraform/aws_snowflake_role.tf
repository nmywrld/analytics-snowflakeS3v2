## this file is for attaching the permissions to snowflake to access S3


data "aws_iam_policy_document" "snowflake_integration" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}"
    ]
  }
}

data "aws_iam_policy_document" "snowflake_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.snowflake_account_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        var.snowflake_external_id
      ]
    }
  }
}

resource "aws_iam_role" "role_for_snowflake_load" {
  name = "${local.prefix}-snowflake-role-${terraform.workspace}"
  description = "AWS role for Snowflake"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role.json
  tags = local.default_tags
}

# data "template_file" "snowflake_load_policy_template" {
#   template = "${data.aws_iam_policy_document.snowflake_integration}"
#   vars = {
#     bucket_name = local.bucket_name
#   }
# }

resource "aws_iam_policy" "snowflake_load_policy" {
  name        = "${local.prefix}-snowflake-access-${terraform.workspace}"
  description = "Allow authorised snowflake users to list files, read from S3 bucket."
  policy = "${data.aws_iam_policy_document.snowflake_integration.json}"
}  

resource "aws_iam_role_policy_attachment" "role_for_snowflake_load_policy_attachment" {
  role       = aws_iam_role.role_for_snowflake_load.name
  policy_arn = aws_iam_policy.snowflake_load_policy.arn
}