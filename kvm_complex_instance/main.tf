#####################################################################
#      DISCO SISTEMA OPERATIVO BASADO EN QCOW
#####################################################################
resource "libvirt_volume" "rs_vol_SO" {
  name   = "${var.nombre}.qcow2"
  source = var.os_base_path
  format = "qcow2"
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
  # Tamaño expresado en megabytes
  size = each.value
}


################################################################
# Se genera la instancia/vm
################################################################

# Creo las vms necesarias
resource "libvirt_domain" "complex_node_kvm_v1" {

  name   = var.nombre
  memory = var.assigned_memory_mb
  vcpu   = var.assigned_memory_cpu


  # Asigno el disco base de SO
  disk {
    volume_id = libvirt_volume.rs_vol_SO.id
  }


  # cloudinit = libvirt_cloudinit_disk.rs_vol_cloud_init.id

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

      # addresses      = ["10.17.3.3"]
      # Si tienen la misma longitud significa que estan especificadas ips fijas, caso contrario paso "" que es el null de esta operacion
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
