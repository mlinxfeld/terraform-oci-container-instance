resource "oci_container_instances_container_instance" "FoggyKitchenContainerInstance" {
  depends_on          = [null_resource.deploy_to_ocir]
  provider            = oci.targetregion
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availablity_domain_name

  image_pull_secrets {
    registry_endpoint = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/"
    secret_type       = "BASIC"
    username          = base64encode("${local.ocir_namespace}/${var.ocir_user_name}")
    password          = base64encode(var.ocir_user_password)
  }

  containers {
    image_url    = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/fknginx:latest"
    display_name = "FoggyKitchenContainerInstance"

    health_checks {
      health_check_type        = "HTTP"
      path                     = "path"
      port                     = "10"
    }
    is_resource_principal_disabled = "false"
    resource_config {
      memory_limit_in_gbs = "1.0"
      vcpus_limit         = "1.0"
    }
    working_directory = "/mnt"
  }
  shape = var.container_instance_shape

  shape_config {
    memory_in_gbs = var.container_instance_shape_memory
    ocpus         = var.container_instance_shape_ocpus
  }
  vnics {
    subnet_id = oci_core_subnet.FoggyKitchenContainerInstanceSubnet.id
    is_public_ip_assigned = var.enable_ephemeral_public_ip
  }
  
   environment_variables = {
      "NGINX_PORT" = var.nginx_port
   }
  
  display_name = "FoggyKitchenContainerInstance"
  state        = "ACTIVE"
}
