# Must be defined using -var switch

variable "layer" {
}

variable "state_bucket" {
}

variable "state_region" {
}

# Defined in the environments <env>/tfvars.file
variable "region" {
}

variable "tags" {
  type = map(string)
}

variable "network" {
  type = map(string)
}

