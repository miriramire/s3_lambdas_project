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
module "lambda" {
  source           = "../../"
  description      = "Example AWS Lambda using python with S3 trigger"
  filename         = var.lambda.lambda_zip_location
  function_name    = var.lambda.function_name
  handler          = var.lambda.handler
  runtime          = var.lambda.runtime
  # source_code_hash = filebase64sha256("${var.lambda.lambda_zip_location}")

  event = {
    type          = "s3"
    s3_bucket_arn = module.s3_bucket_landing.s3_bucket_arn
    s3_bucket_id  = "${var.s3_bucket_landing.name}/${var.s3_bucket_landing.input}"
  }
}