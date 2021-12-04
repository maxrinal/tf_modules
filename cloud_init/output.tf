output "out_vars" {
  value = data.template_file.init
}

output "out_rendered" {
  value = data.template_cloudinit_config.config.rendered
}
