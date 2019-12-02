resource "aws_vpc" "vpc_aspect" {
  cidr_block           = var.network["cidr"]
  enable_dns_hostnames = true

  tags = module.label.tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc_aspect.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [
    aws_route_table.private_route_table.id,
  ]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_aspect.id
  tags   = module.label.tags
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.private_vpc_aspect_a.id
  depends_on    = [aws_internet_gateway.internet_gateway]
}

