terraform {
  backend "s3" {}
}

provider "aws" {
  max_retries = 10
  region      = "${var.region}"
}

# Shared infrastructure state stored in s3
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.state_bucket}"
    key    = "${var.tags["project"]}_${var.tags["environment"]}/vpc.tfstate"
    region = "${var.region}"
  }
}
