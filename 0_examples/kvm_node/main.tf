variable "nombre" { default = "testvm" }
variable "user_name" { default = "pepe" }
variable "user_pass" { default = "Test123456" }

module "cloud_init_disk" {
  source = "/home/repo/tf_modules/cloud_init"

  nombre = var.nombre

  search_domain         = ".asdf.asdf"
  user_name             = var.user_name
  user_default_password = var.user_pass


}

module "node" {
  source = "/home/repo/tf_modules/kvm_complex_instance"

  # -- # Para crear multiples instancias
  # count = 2
  # nombre = "${var.nombre}-node-${count.index}"

  # -- # Para crear una instancia
  nombre = var.nombre

  cloud_init_data = module.cloud_init_disk.out_rendered
  # cloud_init_data = ""


  assigned_memory_cpu = 2
  assigned_memory_mb  = 384
  # os_base_path = "/home/repo/images/cirros-0.5.2-x86_64-disk.img"
  # os_base_path = "/home/repo/images/focal-server-cloudimg-amd64.img"
  # os_base_path = "/home/repo/images/debian-11-generic-amd64-20211011-792.qcow2"
  # os_base_path = "/home/repo/images/debian-11-genericcloud-amd64-20211011-792.qcow2"
  os_base_path = "/home/repo/images/debian-10-generic-amd64-20211011-792.qcow2"
  # os_base_path = "/home/repo/images/debian-10-genericcloud-amd64-20211011-792.qcow2"
  # os_base_path = "/home/repo/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2"
  
  # disk_list             = { "docker" : 1024, "data" : 512 }
  # network_name_list     = ["default", "default"]
  # network_name_list = ["default", "default"]
  network_name_list = ["default"]
  network_wait_dhcp_lease = true
}




output "name" {
  value = module.node.*.name
}
output "ipv4_addressess" {
  value = module.node.*.ipv4_addressess
}
output "clean_out" {
  value = module.node.*.clean_out
}

###- ##Creacion de inventario para kubespray
resource "local_file" "inventory_ansible" {
  content = templatefile("../templates/inventory.tmpl",
    {
      # hosts_ipv4 = resource.libvirt_domain.complex_node_kvm_v1.*.network_interface.0.addresses.0
      # hosts_name = resource.libvirt_domain.complex_node_kvm_v1.*.name
      # Cada vm puede tener una lista de ips
      # hosts_ipv4 = flatten(module.node.*.ipv4_addressess)
      # hosts_name = module.node.*.name
      host_list  = module.node.*.clean_out
      hosts_user = var.user_name
    }
  )
  filename = "/tmp/test.yml"
}


# resource "null_resource" "excute_ansible_k3s" {
#   depends_on = [
#     resource.libvirt_domain.complex_node_kvm_v1,
#     resource.local_file.inventory_k3s
#   ]
#   provisioner "local-exec" {
#     command = "cd ../ansible/ && ansible-playbook playbook.yml -i inventory/sample/hosts.yml"
#   }
# }
