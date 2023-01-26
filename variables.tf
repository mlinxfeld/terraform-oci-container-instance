variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "ocir_user_name" {}
variable "ocir_user_password" {}

variable "availablity_domain_name" {
  default = ""
}

variable "container_instance_shape" {
  default = "CI.Standard.E4.Flex"
}

variable "container_instance_shape_memory" {
  default = 2
}

variable "container_instance_shape_ocpus" {
  default = 1
}

variable "ocir_namespace" {
  default = ""
}

variable "ocir_repo_name" {
  default = "fknginx"
}

variable "ocir_docker_repository" {
  default = ""
}

variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR              = "10.20.0.0/16"
    CONTAINER-SUBNET-CIDR = "10.20.30.0/24"
    ALL-CIDR              = "0.0.0.0/0"
  }
}


