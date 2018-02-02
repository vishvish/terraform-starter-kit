resource "aws_s3_bucket" "example" {
  bucket        = "${var.tags["project"]}_${var.tags["environment"]}_my_example_bucket"
  force_destroy = true

  tags = "${merge(
    var.tags,
    map("Description", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer} Example Bucket"),
    map("Name", "${var.tags["project"]}_${var.tags["environment"]}_${var.layer} Bucket"),
    map("layer", "${var.layer}"),
  )}"
}
