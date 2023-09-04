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
    source_file = string
    function_name = string
    handler = string
    lambda_zip_location = string
    runtime = string
  })

  default = {
    source_file = "lambdafunc.py"
    function_name = "lambdafunc"
    handler = "lambdafunc.lambda_handler"
    lambda_zip_location = "outputs/lambdafunc.zip"
    runtime = "python3.10"
  }
  
}
