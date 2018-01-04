resource "aws_s3_bucket" "infrastructure" {
  bucket        = "${var.state_bucket}_${data.terraform_remote_state.vpc.vpc_id}"
  force_destroy = true

  tags = "${merge(
    var.tags,
    map("Description", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer}"),
    map("Name", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer}"),
    map("layer", "${var.layer}"),
  )}"
}
