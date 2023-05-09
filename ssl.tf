resource "local_file" "ssl_cert" {
  content  = var.ssl_cert
  filename = "${path.module}/config/fullchain.pem"
}

resource "local_file" "ssl_key" {
  content  = var.ssl_key
  filename = "${path.module}/config/privkey.pem"
}
