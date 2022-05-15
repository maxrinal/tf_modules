#####################################################################
#      DISCO SISTEMA OPERATIVO BASADO EN QCOW
#####################################################################
# resource "libvirt_volume" "rs_vol_SO" {
#   name   = "${var.nombre}.qcow2"
#   source = var.os_base_path
#   format = "qcow2"
# }


# # Base OS image to use to create a cluster of different
# # nodes
# resource "libvirt_volume" "opensuse_leap" {
#   name   = "opensuse_leap"
#   source = "http://download.opensuse.org/repositories/Cloud:/Images:/Leap_42.1/images/openSUSE-Leap-42.1-OpenStack.x86_64.qcow2"
# }

# # volume to attach to the "master" domain as main disk
# resource "libvirt_volume" "master" {
#   name           = "master.qcow2"
#   base_volume_id = libvirt_volume.opensuse_leap.id
# }

# - # Base OS image to use to create a cluster of different nodes
resource "libvirt_volume" "base_leap" {
  name   = "${var.nombre}-leap.qcow2"
  source = var.os_base_path
  format = "qcow2"
}

# volume to attach to the "master" domain as main disk
resource "libvirt_volume" "rs_vol_SO" {
  name   = "${var.nombre}-root.qcow2"
  base_volume_id = libvirt_volume.base_leap.id
  # TODO : size = var.os_disk_size_in_bytes
  # TODO : size = var.os_disk_size_in_mb * 1024
  # TODO : size = var.os_disk_size_in_gb * 1024 * 1024
  # Size is expressed in bytes
  size = var.os_disk_size_mb * 1024 * 1024
}


######################################################################
#        DISCO CLOUD INIT BASADO EN TEMPLATE
######################################################################

# Creo el cloudinit disk para cada una de las vms
resource "libvirt_cloudinit_disk" "rs_vol_cloud_init" {
  # TODO AJUSTAR SI RECIBE CLOUD INIT DATA
  # count = length(var.cloud_init_data) > 0 ? 1 : 0
  name = "${var.nombre}-cloud-init.iso"
  user_data = var.cloud_init_data

}

################################################################
# Discos adicionales para la vm
################################################################

resource "libvirt_volume" "rs_vol_extra_disk" {
  for_each = var.disk_list

  name = "${var.nombre}-disk-${each.key}"
  # size es tamaño expresado en bytes
  # 1024(kb) * 1024(mb) * 1024(gb)  
  size = each.value * 1024 * 1024 * 1024
}


################################################################
# Se genera la instancia/vm
################################################################

# Creo las vms necesarias
resource "libvirt_domain" "complex_node_kvm_v1" {

  name   = var.nombre
  memory = var.assigned_memory_mb
  vcpu   = var.assigned_cpu


  # Asigno el disco base de SO
  disk {
    volume_id = libvirt_volume.rs_vol_SO.id
  }


  # Asigno un disco de cloud init si existe
  # if( libvirt_cloudinit_disk.rs_vol_cloud_init ){
  # cloudinit = length(libvirt_cloudinit_disk.rs_vol_cloud_init)  ? libvirt_cloudinit_disk.rs_vol_cloud_init[0].id : null

  # }
  cloudinit = libvirt_cloudinit_disk.rs_vol_cloud_init.id


  # Agrego el resto de los discos generados dinamicamente
  dynamic "disk" {
    for_each = libvirt_volume.rs_vol_extra_disk
    content {
      volume_id = disk.value.id
    }
  }

  dynamic "network_interface" {
    for_each = var.network_name_list
    content {
      network_name   = network_interface.value
      hostname       = var.nombre
      wait_for_lease = var.network_wait_dhcp_lease

      # Si tienen la misma longitud significa que estan especificadas ips fijas, caso contrario paso null
      addresses = ( length( var.network_fixed_ip_list ) == length(var.network_name_list) )  ?  [var.network_fixed_ip_list[network_interface.key]] : null
      # addresses = null

    }
  }


  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }


}
