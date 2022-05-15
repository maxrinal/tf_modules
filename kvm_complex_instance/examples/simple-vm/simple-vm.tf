module "node" {
  source = "/home/repo/tf_modules/kvm_complex_instance"

  # -- # Para crear multiples instancias
  # count = 2
  # nombre = "${var.nombre}-node-${count.index}"

  # -- # Para crear una instancia
  nombre = "testvm"

  # base64=gzip=false
  # cloud_init_data = ""
  # cloud_init_data = data.template_cloudinit_config.config.rendered # https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#rendered
  # cloud_init_data = module.cloud_init_disk.out_rendered
  # cloud_init_data = "#cloud-config\nhostname: instance_1.example.com\nfqdn: instance_1.example.com"
  cloud_init_data = <<EOT
#cloud-config
# vim: syntax=yaml
timezone: "America/Argentina/Buenos_Aires"
ssh_pwauth: True
users:
  - name: vmadmin
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn2AKlXE13gEit1Y67ukhd593LnRPdBGeuUlceeZ99GFOlF1CllPHFPVSK66OzrcVTeHlkD1ToJsuq1FNwds1YdWDHfw6l91Giba2QgHMDQGZp7Uylkd4Epxd827t7AxH8R2VwKeEv2qSS5dh5UDXIbKggHBDfs9HHWD+vMaS/qmWxfA9LX8nK1FUTbdPECau/0u3k8Ozd0ReBj03pHvfu45/H9psEAwKMP+MxRkx/35pOHN7reqVacugJpFQdZPJ/XCOlkBa0vVA/JMddZPFYUrw+/oGdPxEISwExG9NvP+9uVs1b+Ymc6pBhPuz8emZituXIfHviklXB5A9i7ECJuDhUJmkLiIRNAM4KYZqlhMv7coRJVDigmRhrTk1ODZjd+GwcBYAZGbo5SMp1sTZum8DpTlfVpv6jxVPpHwe0LY0y5RpYEHyUFzu6eRQi3H+nJGMq+eWPWR9RTL9LkakHxsN3cDbo184Q9DBSfdDzq8n4cVArgq0nMWh6wZP7TeU= max@rinal
disable_root: false
chpasswd:
  list: |
    root:linux
    vmadmin:Windows7
  expire: false
growpart:
  mode: auto
  devices: ['/']
# runcmd:
#    - timedatectl set-timezone America/Argentina/Buenos_Aires
# https://cloudinit.readthedocs.io/en/latest/topics/modules.html

EOT



  assigned_memory_cpu   = 2
  assigned_memory_mb    = 2048
  # Centos fixed ip address doesnt work
  # os_base_path          = "/home/repo/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2"
  # os_base_path          = "/home/repo/images/focal-server-cloudimg-amd64.img"
  os_base_path          = "/home/repo/images/debian-11-generic-amd64-20211011-792.qcow2"
  # os_base_path          = "/home/repo/images/cirros-0.5.2-x86_64-disk.img"
  # disk_list             = { "docker" : 1024, "data" : 512 }
  # network_name_list     = ["default", "default"]
  network_name_list     = ["default"]
  network_wait_dhcp_lease = true
  # network_fixed_ip_list = []
  # network_fixed_ip_list = ["192.168.122.11"]

}


output "full_node" {
  value = module.node
}


output "ssh_conn" {
  value = <<EOT
ssh -o StrictHostKeyChecking=no vmadmin@${module.node.ipv4_addressess[0]}
EOT
}
