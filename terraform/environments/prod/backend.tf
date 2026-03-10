terraform {
  backend "s3" {
    bucket         = "minecloud-tfstate"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "minecloud-tfstate-lock"
    encrypt        = true
  }
}