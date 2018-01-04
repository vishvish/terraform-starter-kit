# Must be defined using -var switch

variable layer {}
variable region {}
variable state_bucket {}

# Defined in the environments <env>/tfvars.file
variable tags {
  type = "map"
}

variable network {
  type = "map"
}
