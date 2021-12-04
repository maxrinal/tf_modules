# CLOUD INIT VALID MODULES/BLOCKS
# https://cloudinit.readthedocs.io/en/latest/topics/modules.html

variable "nombre" { default = "nombre" }
variable "search_domain" { default = ".ingress.lab.home" }
variable "pub_key_path" { default = "~/.ssh/id_rsa.pub" }
variable "user_name" { default = "appserv" }
variable "user_default_password" { default = "Windows7" }
variable "gzip" {default=false}
variable "base64_encode" {default=false}


data "template_file" "init" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    host_name     = var.nombre
    search_domain = var.search_domain



    user_name             = var.user_name
    user_default_password = var.user_default_password
    auth_key              = file(var.pub_key_path)
  }
}


data "template_cloudinit_config" "config" {
  gzip          = var.gzip
  base64_encode = var.base64_encode

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init.rendered
  }

}