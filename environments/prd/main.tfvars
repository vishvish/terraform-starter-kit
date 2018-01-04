# AMI - Ubuntu Trusty
base_ami = "ami-0ac8fd79"

region = "eu-east-1"

tags = {
  project           = "platform"
  email             = "owner@example.com"
  owner             = "Owner Name"
  live              = "yes"
  technical-contact = "owner@example.com"
  environment       = "prd"
}

# NETWORK RANGES
network = {
  cidr      = "10.8.241.0/24"
  private_a = "10.8.241.0/26"
}
