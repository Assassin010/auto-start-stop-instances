############################ BACKEND #################################
terraform {
  backend "s3" {
    bucket         = "auto-start-stop-remotestate-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "auto-start-stop-state-lock-us-east-1"
    encrypt        = true
    profile        = "<NAME OF YOUR PROFILE HERE>" 
    role_arn       = "<ROLE ARN HERE>"
    session_name   = "Gauthier_Kwatatshey"
  }
}

############################ REMONTE STATE #############################

resource "aws_s3_bucket" "backend" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags
  )
}

resource "aws_s3_bucket_acl" "acl_backend" {
  bucket = aws_s3_bucket.backend.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    aws_s3_bucket.backend
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.backend.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
