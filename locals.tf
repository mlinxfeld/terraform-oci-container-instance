locals {
  http_port_number                        = var.nginx_port
  https_port_number                       = var.nginx_ssl_port
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"

  ocir_docker_repository        = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace                = lookup(data.oci_objectstorage_namespace.test_namespace, "namespace")
  enable_ssl                    = var.enable_ssl ? ".ssl" : ".nossl"
}
