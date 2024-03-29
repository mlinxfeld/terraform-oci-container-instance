resource "oci_artifacts_container_repository" "FoggyKitchenArtifactsContainerRepository" {
  provider       = oci.targetregion
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "${var.ocir_repo_name}/fknginx"
  is_public      = false
}

resource "null_resource" "deploy_to_ocir" {
  depends_on = [ oci_artifacts_container_repository.FoggyKitchenArtifactsContainerRepository]

  provisioner "local-exec" {
    command = "echo '${local.ocir_user_password}' |  docker login ${local.ocir_docker_repository} --username ${local.ocir_user_name} --password-stdin"
  }

  provisioner "local-exec" {
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
  }

  provisioner "local-exec" {
    command = "docker build -f docker/Dockerfile${local.enable_ssl} --build-arg NGINX_PORT=${var.nginx_port} --build-arg NGINX_SSL_PORT=${var.nginx_ssl_port} --build-arg HOST_NAME=${var.dns_domain} -t fknginx ."
  }  

  provisioner "local-exec" {
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker tag $image ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/fknginx:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/fknginx:latest"
  }  

  provisioner "local-exec" {
    when    = destroy
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
  }
}  

