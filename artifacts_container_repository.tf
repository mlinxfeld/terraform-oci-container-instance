resource "oci_artifacts_container_repository" "FoggyKitchenArtifactsContainerRepository" {
  provider       = oci.targetregion
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name   = "${var.ocir_repo_name}/fknginx"
  is_public      = false
}

resource "local_file" "indexhtml_deployment" {
  content  = data.template_file.indexhtml_deployment.rendered
  filename = "${path.module}/index.html"
}

resource "local_file" "dockerfile_deployment" {
  content  = data.template_file.dockerfile_deployment.rendered
  filename = "${path.module}/dockerfile"
}


resource "local_file" "nginxconf_deployment" {
  content  = data.template_file.nginxconf_deployment.rendered
  filename = "${path.module}/nginx.conf"
}

resource "null_resource" "deploy_to_ocir" {
  depends_on = [
  local_file.indexhtml_deployment,
  local_file.dockerfile_deployment,
  oci_artifacts_container_repository.FoggyKitchenArtifactsContainerRepository
  ]

  provisioner "local-exec" {
    command = "echo '${var.ocir_user_password}' |  docker login ${local.ocir_docker_repository} --username ${local.ocir_namespace}/${var.ocir_user_name} --password-stdin"
  }

  provisioner "local-exec" {
    command = "image=$(docker images | grep fknginx | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
  }

  provisioner "local-exec" {
    command = "docker -f docker/Dockerfile --build-arg NGINX_PORT=${var.nginx_port} -t fknginx ."
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

