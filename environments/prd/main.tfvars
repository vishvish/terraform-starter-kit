# AMI - Ubuntu Trusty
base_ami = "ami-0ac8fd79"

region = "us-east-1"

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
  cidr      = "10.8.240.0/24"
  private_a = "10.8.240.0/26"
  public_a  = "10.8.240.64/26"
}
