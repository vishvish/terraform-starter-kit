resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_aspect.id
  tags   = module.label.tags
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_vpc_aspect_a.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_aspect.id
  tags   = module.label.tags
}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_a.id
}

resource "aws_route" "outbound_nat" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  route_table_id         = aws_route_table.private_route_table.id
}

resource "aws_route" "outbound_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
  route_table_id         = aws_route_table.public_route_table.id
}

