output "full_output" {
  value = libvirt_domain.complex_node_kvm_v1
}
output "name" {
  value = libvirt_domain.complex_node_kvm_v1.name
}
output "ipv4_addressess" {
  # Usando flatten transformo una lista de listas en una simple lista
  value = flatten(libvirt_domain.complex_node_kvm_v1.network_interface.*.addresses)
}
output "clean_out" {
  value = {
      "name" : libvirt_domain.complex_node_kvm_v1.name,
      "ipv4_addressess" : flatten(libvirt_domain.complex_node_kvm_v1.network_interface.*.addresses),
      "disk_list" : flatten(libvirt_domain.complex_node_kvm_v1.disk.*.volume_id),
    } 
}
