################################################################
# Primero se deben crear los discos
################################################################
resource "openstack_blockstorage_volume_v2" "simple_os_volume_v1" {
  for_each = var.disk_list

  name = "${var.name}-disk-${each.key}"
  size = each.value

  volume_type       = var.volume_type
  availability_zone = var.availability_zone
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################
# Se genera la instancia/vm
################################################################

resource "openstack_compute_instance_v2" "complex_node_v1" {
  name        = var.name
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = var.keypair

  dynamic "network" {
    for_each = var.network_list
    content {
      name = network.value
      # Si tienen la misma longitud significa que estan especificadas ips fijas, caso contrario paso "" que es el null de esta operacion
      fixed_ip_v4 = ( length( var.network_fixed_ip_list ) == length(var.network_list) )  ?  var.network_fixed_ip_list[network.key] : "" 
    }
  }

}

################################################################
# Hago los attach cuando la vm y el disco esten listos
################################################################

resource "openstack_compute_volume_attach_v2" "all-volume-attach" {
  for_each = openstack_blockstorage_volume_v2.simple_os_volume_v1
  
  depends_on = [
    openstack_compute_instance_v2.complex_node_v1,
    openstack_blockstorage_volume_v2.simple_os_volume_v1,
  ]

  instance_id = openstack_compute_instance_v2.complex_node_v1.id
  volume_id   = each.value.id

  vendor_options {
    ignore_volume_confirmation = var.ignore_volume_confirmation
  }
}


resource "null_resource" "validate_vm_reachable" {
  depends_on = [
    # time_sleep.wait_60_sec
    openstack_compute_volume_attach_v2.all-volume-attach
  ]
  # Hack para que de por finalizada la creacion solo si puede hacer ssh
  provisioner "remote-exec" {
    inline = ["echo '###### VM is created ######'", "/bin/lsblk"]
    connection {
      # host  = self.access_ip_v4
      host  = openstack_compute_instance_v2.complex_node_v1.access_ip_v4
      type  = "ssh"
      # user  = "appserv"
      user  = var.default_ssh_user
      agent = true
    }
  }
}


