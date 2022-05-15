# TODO:  Seria ideal agregar data sources, para listar los tipos validos en cada parametro
variable "flavor" {
  description = "Debe recibir un flavor valido, por ejemplo, flavor=\"CPU2RAM4096HD10GB\""
  type        = string
}
variable "image" {
  description = "Debe recibir una imagen valida por ejemplo: image=\"CentOS7.9-V1.0\""
  type        = string
}
variable "keypair" {
  description = "Debe recibir el nombre de una keypair valida previamente subida a openstack con  openstack keypair create --public-key xxxx_path keypair"
  type        = string
}
variable "network_list" {
  description = "Debe recibir una lista de redes valida el minimo es cero( disk_list = []). disk_list = [\"n1\",\"n1\"]"
  type        = list
#   default     =  []
}
variable "network_fixed_ip_list" {
  description = "Debe recibir una lista de ips validas el minimo es cero para dinamicas( network_fixed_ip_list = []). network_fixed_ip_list = [\"10.30.188.15\",\"10.30.188.16\",\"10.30.188.17\"]"
  type        = list
  default     =  []
}
variable "name" {
  description = "Debe recibir un nombre"
  type        = string
}
variable "disk_list" {
  description = "Debe recibir una map de nombres de disco y su tamanio expresado en Gygabytes, el minimo es cero({}). disk_list = { \"docker\" : 4, \"database\" : 1, }"
  type        = map
  default     = {}
}

variable "volume_type" {
  description = "Volume type"
  type        = string
  default     = "__DEFAULT__"
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "nova"
}


variable "default_ssh_user" {
  description = "Debe recibir un string con el nombre de usuario por default para intentar conectarse via ssh"
  type        = string
  default     = "appserv"
}


variable "ignore_volume_confirmation" {
  description = "Recibe un bool true/false indicando si esperar a que se complete el attach del volume o no. En la experiencia se requiere true para openstack icehouse "
  type        = bool
  default     = true
}



