module "instancia_1" {
#  source = "../complex_instance"
  source = "/home/repo/tf_modules/os_complex_node/"

  # Para crear multiples instancias
  # count   = 2
  # name    = "mr-test-module-node-${count.index}"
  # Para crear una instancia
  name    = "mr-test"

  keypair = "mrinaldi"

  image  = "CentOS7.9-V1.0"
  flavor = "CPU1RAM1024HD5GB"

  # network_list = []                # Ninguna red
  network_list = ["vdesa"]              # Una red
  # network_list = ["n1", "n1" ....] # Mas de una red

  # Misma cantidad de ips que placas de red
  # network_fixed_ip_list = []
  # network_fixed_ip_list = ["10.4.18.108", "10.4.18.109"]



  # Ningun disco extra
  # disk_list = {}
  disk_list = {
    "a" : 1,
  }

  volume_type = ""
  availability_zone =""

}


output "instancia_1_info" {
  value = module.instancia_1
}
