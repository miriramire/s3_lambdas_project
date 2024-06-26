# S3 Bucket
module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "input_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.input}/"
}

resource "aws_s3_object" "output_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.output}/"
}

# My lambda function
data "archive_file" "lambdafunc" {
    type = "zip"
    source_file = "${var.lambda.source_file}"
    output_path = "${var.lambda.lambda_zip_location}"
}
resource "aws_lambda_function" "s3_transform_function" {
  function_name    = var.lambda.function_name
  description      = "Example AWS Lambda using python with S3 trigger"
  handler          = var.lambda.handler
  runtime          = var.lambda.runtime
  filename         = var.lambda.lambda_zip_location

  role          = "${aws_iam_role.lambda_role.arn}"
  #source_code_hash = filebase64sha256("${var.lambda.lambda_zip_location}")
  source_code_hash = data.archive_file.lambdafunc.output_base64sha256
}

resource "aws_s3_bucket_notification" "s3_event_trigger" {
  bucket = var.s3_bucket_landing.name

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_transform_function.arn
    events             = ["s3:ObjectCreated:*"]
    filter_prefix      = "${var.s3_bucket_landing.input}"
    filter_suffix      = ""
  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.s3_transform_function.function_name}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${var.s3_bucket_landing.name}"
}
