variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name    = string
    input   = string
    output  = string
  })

  default = {
    name    = "landing-test-data-terraform-project-101"
    input   = "input"
    output  = "output"
  }
}

variable "lambda" {
  description = "Lambda details"
  type = object({
    function_name = string
    handler = string
    lambda_zip_location = string
    runtime = string
  })

  default = {
    function_name = "lambda_s3"
    handler = "welcome.hello"
    lambda_zip_location = "outputs/welcome.zip"
    runtime = "python3.10"
  }
  
}
