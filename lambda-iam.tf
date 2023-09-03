resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = "${file("iam/lambda-policy.json")}"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = "${file("iam/lambda-assume-policy.json")}"
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-policy"
  description = "Policy for Lambda function to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket_landing.name}/${var.s3_bucket_landing.input}/*"
      },
      {
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket_landing.name}/${var.s3_bucket_landing.output}/*" 
      }
    ]
  })
}