# AMI - Ubuntu Trusty
# base_ami = "ami-0ac8fd79"

region = "eu-west-2"

tags = {
  namespace    = "tsk"
  stage        = "dev"
  name         = "terraform-starter-kit"
  attributes   = "public"
  businessunit = "github"
  owner        = "Owner Person"
  email        = "owner@example.com"
}

# NETWORK RANGES
network = {
  cidr      = "10.8.240.0/24"
  private_a = "10.8.240.0/26"
  public_a  = "10.8.240.64/26"
}
