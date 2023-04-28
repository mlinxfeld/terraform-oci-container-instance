output "FoggyKitchenContainerInstance_VNIC1_OCID" {
  value = oci_container_instances_container_instance.FoggyKitchenContainerInstance.vnics[0].vnic_id
}

output "FoggyKitchenContainerInstance_IPS1" {
  value = data.oci_core_private_ips.FoggyKitchenContainerInstance_IPS1.private_ips[0]
}

