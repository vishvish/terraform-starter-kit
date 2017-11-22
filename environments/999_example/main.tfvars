# AMI - Ubuntu Trusty
base_ami = "ami-0ac8fd79"

region = "eu-west-1"

tags = {
  project           = "platform"
  email             = "<owner@example.com>"
  owner             = "<Owner Name>"
  live              = "no"
  technical-contact = "<owner@example.com>"
  environment       = "dev"
}

# NETWORK RANGES
network = {
  cidr      = "10.8.240.0/24"
  private_a = "10.8.240.0/26"
}
