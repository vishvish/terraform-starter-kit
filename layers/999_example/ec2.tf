resource "aws_instance" "example" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id = "${data.terraform_remote_state.vpc.public_subnet_a_id}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.sg01_id}"
  ]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = "${merge(
    var.tags,
    map("Description", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer} Example Instance"),
    map("Name", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer} Instance" ),
    map("layer", "${var.layer}"),
  )}"
}
