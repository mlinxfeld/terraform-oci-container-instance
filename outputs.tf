output "FoggyKitchenContainerInstancePublicIP" {
   value = data.oci_core_vnic.FoggyKitchenContainerInstanceVnic.public_ip_address
}

