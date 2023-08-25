# S3 Bucket
module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_bucket_object" "input_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.input}/"
}

#resource "aws_s3_object" "input_path" {
#  bucket = var.s3_bucket_landing.name
#  acl    = "private"
#  key    = "${var.s3_bucket_landing.input}"
#  source = "/${var.s3_bucket_landing.input}"
#  etag = filemd5("/${var.s3_bucket_landing.input}")
#}

#resource "aws_s3_object" "output_path" {
#  bucket = module.s3_bucket_landing.s3_bucket_id
#  key    = var.s3_bucket_landing.output
#  source = var.s3_bucket_landing.output
#}