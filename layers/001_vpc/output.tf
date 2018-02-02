output "vpc_id" {
  value = "${aws_vpc.vpc_aspect.id}"
}
output "sg01_id" {
  value = "${aws_security_group.sg01.id}"
}
output "public_subnet_a_id"{
  value = "${aws_subnet.public_subnet_a.id}"
}
