data "oci_identity_region_subscriptions" "home_region_subscriptions" {

  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  provider       = oci.targetregion
  compartment_id = var.tenancy_ocid
}

data "oci_identity_regions" "oci_regions" {
  provider   = oci.homeregion
  filter {
    name   = "name"
    values = [var.region]
  }

}

data "oci_objectstorage_namespace" "test_namespace" {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
}




data "oci_core_vnic" "FoggyKitchenContainerInstanceVnic" {
  depends_on = [
    oci_container_instances_container_instance.FoggyKitchenContainerInstance, 
    oci_core_public_ip.FoggyKitchenContainerInstance_PublicReservedIP
  ]
  provider   = oci.targetregion
  vnic_id = oci_container_instances_container_instance.FoggyKitchenContainerInstance.vnics[0].vnic_id
}

data "oci_core_private_ips" "FoggyKitchenContainerInstance_IPS1" {
  depends_on = [
    oci_container_instances_container_instance.FoggyKitchenContainerInstance, 
    oci_core_public_ip.FoggyKitchenContainerInstance_PublicReservedIP
  ]
  provider   = oci.targetregion
  vnic_id    = oci_container_instances_container_instance.FoggyKitchenContainerInstance.vnics[0].vnic_id
  subnet_id  = oci_core_subnet.FoggyKitchenContainerInstanceSubnet.id
}
