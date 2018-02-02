resource "aws_security_group" "sg01" {
  vpc_id = "${aws_vpc.vpc_aspect.id}"
  name = "terraform-example-instance"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
