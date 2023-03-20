######################## LAMBDA S3 BUCKET ########################
resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda-auto-start-stop-us-east-1"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true

  tags = merge(
    local.common_tags
  )

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bkt_encryptn" {
  bucket = aws_s3_bucket.lambda_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



##################### LAMBDA DEPLOYMENT PACKAGE #####################
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_start/src"
  output_path = "${path.module}/lambda_start/lambda_handler.zip"
}

resource "aws_s3_object" "lambda_package" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_handler.zip"
  source = data.archive_file.lambda.output_path
  etag   = filemd5(data.archive_file.lambda.output_path)
}


######################################
data "archive_file" "lambda_1" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_stop/src"
  output_path = "${path.module}/lambda_stop/lambda_handler_1.zip"
}

resource "aws_s3_object" "lambda_package_1" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_handler_1.zip"
  source = data.archive_file.lambda_1.output_path
  etag   = filemd5(data.archive_file.lambda_1.output_path)
}
######################## LAMBDA FUNCTION  AUTO STOP ########################
resource "aws_lambda_function" "auto-stop" {
  function_name = var.function_name1
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_package_1.key
  source_code_hash = data.archive_file.lambda_1.output_base64sha256

  runtime     = "python3.9"
  handler     = "main_lambda_1.lambda_handler"
  timeout     = 300
  memory_size = 250

  environment {
    variables = {
      LOG_LEVEL = var.lambda_log_level
    }
  }

  tags = merge(
    local.common_tags
  )


}

######################## LAMBDA LOG GROUP ########################
resource "aws_cloudwatch_log_group" "lambda_log_grp_stop" {
  name              = "/aws/lambda/${var.function_name1}"
  retention_in_days = 30

  tags = merge(
    local.common_tags
  )

}

resource "aws_cloudwatch_log_group" "lambda_log_grp_start" {
  name              = "/aws/lambda/${var.function_name2}"
  retention_in_days = 30

  tags = merge(
    local.common_tags
  )

}


######################## LAMBDA FUNCTION  AUTO START ########################

resource "aws_lambda_function" "auto-start" {
  function_name = var.function_name2
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_package.key
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime     = "python3.9"
  handler     = "main_lambda.lambda_handler"
  timeout     = 300
  memory_size = 250

  environment {
    variables = {
      LOG_LEVEL = var.lambda_log_level
    }
  }

  tags = merge(
    local.common_tags
  )

}

