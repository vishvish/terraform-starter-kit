output example_bucket_id {
  value = "${aws_s3_bucket.example.id}"
}

output public_ip {
  value = "${aws_instance.example.public_ip}"
}
