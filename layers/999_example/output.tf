output "remote-var" {
  value = "${data.terraform_remote_state.vpc.vpc_id}"
}
