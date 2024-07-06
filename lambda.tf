data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./resources/lambda_function.py"
  output_path = "./resources/lambda_function.zip"
}

resource "aws_lambda_function" "my_lambda_function" {
  memory_size   = "256"
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      foo = "bar"
    }
  }
}
