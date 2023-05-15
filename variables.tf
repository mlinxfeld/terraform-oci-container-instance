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
  default = 1
}

variable "container_instance_shape_ocpus" {
  default = 1
}

variable "enable_vault" {
  default = false
}

variable "vault_secret_id" {
  default = ""
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

variable "enable_reserved_public_ip" {
  default = false
}

variable "enable_ephemeral_public_ip" {
  default = true
}

variable "enable_ssl" {
  default = false
}

variable "ssl_cert" {
  type = string
  default = ""
}

variable "ssl_key" {
  type = string
  default = ""
}

variable "nginx_port" {
  default = 80
}

variable "nginx_ssl_port" {
  default = 443
}

variable "enable_dns" {
  default = false
}

variable "dns_domain" {
  default = "foggykitchen.xyz"
}

variable "dns_a_record_ttl" {
  default = 30
}

variable "enable_nsg" {
  default = false
}
