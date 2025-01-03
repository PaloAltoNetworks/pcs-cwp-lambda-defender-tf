data "external" "tw_policy" {
  program = ["bash", "${path.module}/tw-policy.sh"]

  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    pcc_url       = var.console_url
    pcc_user      = var.prisma_username
    pcc_pass      = var.prisma_password
    pcc_san       = var.console_san
    function_name = var.function_name
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "my-function" {
  filename         = "lambda_function_payload.zip"
  function_name    = var.function_name
  layers           = [aws_lambda_layer_version.prismacloud_layer.arn]
  role             = var.function_role
  handler          = "twistlock.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "${var.runtime}${var.runtime_version}"

  environment {
    variables = {
      ORIGINAL_HANDLER = var.original_handler
      TW_POLICY        = "${data.external.tw_policy.result.tw_policy}"
    }
  }
}

