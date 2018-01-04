terraform {
  backend "s3" {}
}

provider "aws" {
  max_retries = 10
  region      = "${var.region}"
}

# Reference remote state data for the VPC layer
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.state_bucket}"
    key    = "${var.tags["project"]}/${var.tags["environment"]}/001_vpc.tfstate"
    region = "${var.region}"
  }
}
