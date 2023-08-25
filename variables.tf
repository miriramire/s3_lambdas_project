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
