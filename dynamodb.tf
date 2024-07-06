resource "aws_dynamodb_table" "fortunes" {
  name           = "fortunes"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "fort_id"
    type = "N"
  }

  hash_key = "fort_id"

  tags = {
    Name        = "fortunes"
    Environment = "dev"
  }

}
