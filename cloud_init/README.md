# Uso del modulo tf_cloud_init

```terraform
module "cloud_init_disk" {
  source = "../tf_cloud_init"

  nombre = var.nombre

  search_domain         = ".asdf.asdf"
  user_name             = "pepe"
  user_default_password = "Test123456"

  # libvirt_cloudinit_disk requires gzip=base64_encode=false
  gzip = false
  base64_encode = false

}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = module.cloud_init_disk.out_rendered
}
```