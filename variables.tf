variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name    = string
    input   = string
    output  = string
  })

  default = {
    name    = "landing_test_data_terraform_project_101"
    input   = "input"
    output  = "output"
  }
}
