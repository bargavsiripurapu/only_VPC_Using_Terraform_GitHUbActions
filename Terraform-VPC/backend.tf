resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  
}
