terraform {
  backend "s3" {
    bucket         = "my-tf-backend1"
    key            = "env/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-tf-lock"
    encrypt        = false
  }
}

