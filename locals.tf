locals {
  http_port_number                        = var.nginx_port
  https_port_number                       = "443"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"

  ocir_docker_repository        = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace                = lookup(data.oci_objectstorage_namespace.test_namespace, "namespace")
  container_instance_url        = !var.enable_ephemeral_public_ip && !var.enable_reserved_public_ip && data.oci_core_vnic.FoggyKitchenContainerInstanceVnic.public_ip_address == null ? "" : (var.nginx_port == "80") ? "http://${data.oci_core_vnic.FoggyKitchenContainerInstanceVnic.public_ip_address}" : "http://${data.oci_core_vnic.FoggyKitchenContainerInstanceVnic.public_ip_address}:${var.nginx_port}/"
}
