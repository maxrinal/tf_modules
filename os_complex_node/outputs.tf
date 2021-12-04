output "instance_id" {
  value = openstack_compute_instance_v2.complex_node_v1.id
}

output "instance_name" {
  value = openstack_compute_instance_v2.complex_node_v1.name
}

# Cuidado!!! Esto solo trae la primera ip
output "instance_ip_v4" {
  value = openstack_compute_instance_v2.complex_node_v1.access_ip_v4
}

output "volume_list" {
  value = {
      for k, v in openstack_blockstorage_volume_v2.simple_os_volume_v1 : k => [v.id,v.name ]
  }
  
}


output "debug_volume"{
  value = openstack_blockstorage_volume_v2.simple_os_volume_v1
}
output "debug_instance"{
  value = openstack_compute_instance_v2.complex_node_v1
}
output "debug_attach"{
  value = openstack_compute_volume_attach_v2.all-volume-attach
}
