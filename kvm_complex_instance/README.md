# Uso del modulo tf_complex_instance_kvm

``` terraform
module "node" {
  source = "../tf_complex_instance_kvm"

  # -- # Para crear multiples instancias
  # count = 2
  # nombre = "${var.nombre}-node-${count.index}"

  # -- # Para crear una instancia
  nombre = var.nombre

  # base64=gzip=false
  cloud_init_data = ""
  # cloud_init_data = data.template_cloudinit_config.config.rendered # https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#rendered
  # cloud_init_data = module.cloud_init_disk.out_rendered
  # cloud_init_data = "#cloud-config\nhostname: instance_1.example.com\nfqdn: instance_1.example.com"



  assigned_memory_cpu   = 2
  assigned_memory_mb    = 2048
  os_base_path          = "/home/repo/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2"
  # disk_list             = { "docker" : 1024, "data" : 512 }
  # network_name_list     = ["default", "default"]
  network_name_list     = ["default"]
}
```