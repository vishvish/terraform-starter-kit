resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc_aspect.id}"

  tags = "${merge(
    var.tags,
    map("Description", "${var.tags["project"]} private routing table"),
    map("Name", "${var.tags["project"]} private routing table"),
    map("layer", "${basename(var.layer)}"),
  )}"
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = "${aws_subnet.private_vpc_aspect_a.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
