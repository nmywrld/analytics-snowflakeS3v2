# create SNS topic

resource "aws_sns_topic" "snowflake_load_bucket_topic" {
  name = "topic-${local.bucket_name}"
  delivery_policy = <<EOF
  {
    "http": {
      "defaultHealthyRetryPolicy": {
        "minDelayTarget": 20,
        "maxDelayTarget": 20,
        "numRetries": 3,
        "numMaxDelayRetries": 0,
        "numNoDelayRetries": 0,
        "numMinDelayRetries": 0,
        "backoffFunction": "linear"
      },
      "disableSubscriptionOverrides": false,
      "defaultThrottlePolicy": {
        "maxReceivesPerSecond": 1
      }
    }
  }
  EOF

  tags = local.default_tags
}  

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.aws_account_id,
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.snowflake_load_bucket_topic.arn
    ]

    sid = "__default_statement_ID"
  }

  statement {
    effect = "Allow"
    actions = [
      "SNS:Subscribe"
    ]

    principals {
      type        = "AWS"
      identifiers = [var.snowflake_account_arn]
    }

    resources = [
      aws_sns_topic.snowflake_load_bucket_topic.arn,
    ]

    sid = "1"
  }  

  statement {
    effect = "Allow"
    actions = [
      "SNS:Publish"
    ]
    resources = [
      aws_sns_topic.snowflake_load_bucket_topic.arn,
    ]

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values = [
        aws_s3_bucket.stage_bucket_load.arn
      ]
    }

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    sid = "s3-event-notifier"
  } 
}

// Attaches the policy to SNS topic
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.snowflake_load_bucket_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}