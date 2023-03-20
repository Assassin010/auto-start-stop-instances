resource "aws_dynamodb_table" "auto-start-stop-lock" {
  name           = var.dynamodb_table_name
  hash_key       = "LockID"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "auto-start-stop-lock"
    }
  )
}
