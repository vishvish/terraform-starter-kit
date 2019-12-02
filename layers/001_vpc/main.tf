terraform {
  backend "s3" {
  }
}

provider "aws" {
  max_retries = 10
  region      = var.region
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace  = var.tags["namespace"]
  stage      = var.tags["stage"]
  name       = var.tags["name"]
  attributes = [var.tags["attributes"]]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = var.tags["businessunit"],
    "Owner"        = var.tags["owner"]
    "Email"        = var.tags["email"]
  }
}
