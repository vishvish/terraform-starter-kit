terraform {
  backend "s3" {}
}

provider "aws" {
  max_retries = 10
  region      = "${var.region}"
}
