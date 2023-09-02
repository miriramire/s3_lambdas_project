locals {
    lambda_zip_location = "outputs/welcome.zip"
}

data "archive_file" "welcome" {
    type = "zip"
    source_file = "welcome.py"
    output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "test_lambda" {
    filename      = "${local.lambda_zip_location}"
    function_name = "welcome"
    role          = "${aws_iam_role.lambda_role.arn}"
    handler       = "welcome.hello"

    runtime = "python3.9"
}