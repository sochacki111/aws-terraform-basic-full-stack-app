data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./resources/lambda/lambda_function.py"
  output_path = "./resources/lambda/lambda_function.zip"
}

resource "aws_lambda_function" "my_lambda_function" {
  memory_size      = "256"
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function_url" "my_lambda_function_url" {
  function_name      = aws_lambda_function.my_lambda_function.function_name
  authorization_type = "NONE"

}

output "my_lambda_function_url" {
  value = aws_lambda_function_url.my_lambda_function_url.function_url
}
