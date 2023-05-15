resource "oci_container_instances_container_instance" "FoggyKitchenContainerInstance" {
  depends_on          = [null_resource.deploy_to_ocir]
  provider            = oci.targetregion
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availablity_domain_name

  image_pull_secrets {
    registry_endpoint = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/"
    secret_type       = var.enable_vault ? "VAULT" : "BASIC"
    username          = var.enable_vault ? null : base64encode("${local.ocir_namespace}/${var.ocir_user_name}")
    password          = var.enable_vault ? null : base64encode(var.ocir_user_password)
    secret_id         = var.enable_vault ? var.vault_secret_id : null
  }

  containers {
    image_url    = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/fknginx:latest"
    display_name = "FoggyKitchenContainerInstance"
    environment_variables = local.environment_variables 
    dynamic "volume_mounts" {
    	for_each = var.enable_ssl ? [1] : []
    	content {
            mount_path  = "/etc/ssl/private/encrypted/"
           volume_name = "ssl_volume"
        }
    }
  }

  shape = var.container_instance_shape

  shape_config {
    memory_in_gbs = var.container_instance_shape_memory
    ocpus         = var.container_instance_shape_ocpus
  }
  vnics {
    subnet_id = oci_core_subnet.FoggyKitchenContainerInstanceSubnet.id
    is_public_ip_assigned = var.enable_ephemeral_public_ip
    nsg_ids = var.enable_nsg ? [oci_core_network_security_group.FoggyKitchenWebSecurityGroup[0].id] : [] 
  }

  dynamic "volumes" {
    for_each = var.enable_ssl ? [1] : []
    content {
     name = "ssl_volume"
     volume_type = "CONFIGFILE"
  
     dynamic "configs" {
       for_each = local.configs
       content {
         data      = base64encode(configs.value.data)
         file_name = configs.value.file_name
       }
     }
   }
  }
  
  display_name = "FoggyKitchenContainerInstance"
  state        = "ACTIVE"
}
