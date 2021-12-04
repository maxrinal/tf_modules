variable "nombre" { default = "test-vm" }

variable "assigned_memory_cpu" { default = 2 }
variable "assigned_memory_mb" { default = 2048 }

# https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img
# After download you must rename and resie the disk "qemu-img resize ubuntu20.qcow2 +8G"
variable "os_base_path" { default = "/home/repo/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2" }
# Tamaño expresado en megabytes
# variable "disk_list" { default = { "docker" : 1024, "data" : 512 } }
variable "disk_list" { default = {} }

# variable "network_name_list" { default = ["default", "default"] }
variable "network_name_list" { default = [] }

# variable "search_domain" { default = ".asdf.asdf" }

# variable "user_name" { default = "centos" }
# variable "user_default_password" { default = "Test123456" }


variable cloud_init_data {default=""}

variable network_wait_dhcp_lease {default=false}

variable "network_fixed_ip_list" {
  description = "Debe recibir una lista de ips validas el minimo es cero para dinamicas( network_fixed_ip_list = []). network_fixed_ip_list = [\"10.30.188.15\",\"10.30.188.16\",\"10.30.188.17\"]"
  type        = list
  default     =  []
}