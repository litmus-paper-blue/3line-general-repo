terraform {
  backend "s3" {
    bucket = "netiks-infra-tfstate-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # profile        = "" // use "export AWS_PROFILE="" in your local terminal
    encrypt = "true"
  }
}