resource "aws_subnet" "private_vpc_aspect_a" {
  availability_zone       = "${var.region}a"
  cidr_block              = var.network["private_a"]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc_aspect.id
  tags                    = module.label.tags
}

resource "aws_subnet" "public_subnet_a" {
  availability_zone       = "${var.region}a"
  cidr_block              = var.network["public_a"]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc_aspect.id
  tags                    = module.label.tags
}

