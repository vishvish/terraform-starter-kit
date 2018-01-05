terraform {
  backend "s3" {}
}

provider "aws" {
  max_retries = 10
  region      = "${var.region}"
}

# Reference remote state data for the VPC layer and current environment
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.state_bucket}"
    key    = "${var.tags["project"]}/${var.tags["environment"]}/001_vpc.tfstate"
    region = "${var.state_region}"
  }
}

# Get the most recent ubuntu AMI in the current region's store
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}
