######################## LAMBDA IAM ROLE ########################
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda-auto-start-stop"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  inline_policy {
    name   = "Auto-start-stop-FunctionPermissions"
    policy = data.aws_iam_policy_document.lambda_inline_policy.json
  }

  tags = merge(
    local.common_tags
  )

}
######################## LAMBDA ROLE TRUST POLICY ########################
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}


######################## LAMBDA ROLE PERMISSIONS ########################
data "aws_iam_policy_document" "lambda_inline_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:Start*",
      "ec2:Stop*",
      "ec2:DescribeInstances*",
    ]
  }

  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["events:*"]
  }

  statement {
    sid       = "AllowLambdaCreateLogGroup"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:*"]
  }
  statement {
    sid     = "AllowLambdaCreateLogStreamsAndWriteEventLogs"
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "${aws_cloudwatch_log_group.lambda_log_grp_stop.arn}:*",
      "${aws_cloudwatch_log_group.lambda_log_grp_start.arn}:*"
    ]
  }
}

######################## CLOUDTRAIL BUCKET POLICY ########################
data "aws_iam_policy_document" "cloudtrail_bucket_policy_doc" {
  count = var.create_trail ? 1 : 0

  statement {
    sid    = "AllowCloudTrailCheckBucketAcl"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_bucket[count.index].arn]
  }

  statement {
    sid    = "AllowCloudTrailWriteLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_bucket[count.index].arn}/AWSLogs/*"]
  }

}
