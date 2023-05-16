
resource "oci_identity_dynamic_group" "FoggyKitchenContainerInstancesDynamicGroup" {
  count          = var.enable_vault && var.enable_vault_iam ? 1 : 0
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  name           = "FoggyKitchenContainerInstancesDynamicGroup"
  description    = "FoggyKitchen Container Instances Dynamic Group"
  matching_rule  = "ALL {resource.type='computecontainerinstance'}"
}


resource "oci_identity_policy" "FoggyKitchenContainerInstancesVaultPolicy" {
  depends_on     = [oci_identity_dynamic_group.FoggyKitchenContainerInstancesDynamicGroup]
  count          = var.enable_vault && var.enable_vault_iam ? 1 : 0
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  name           = "FoggyKitchenContainerInstancesVaultPolicy"
  description    = "FoggyKitchen Container Instances Policy allowing Dynamic Group access Vault"
  
  statements = ["allow dynamic-group FoggyKitchenContainerInstancesDynamicGroup to read secret-bundles in tenancy"]
}

