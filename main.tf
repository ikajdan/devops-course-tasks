terraform {
  backend "s3" {
    bucket = "ikajdan-terraform-state-bucket"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-west-1"
  }
}
