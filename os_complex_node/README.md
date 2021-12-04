# Complex_instance

Se genera un modulo *complejo* para generacion de instancia, el objetivo es que el mismo se comporte como black box/wrapper por encima del provider de virtualizacion y de esa forma no se deban hacer llamadas al provider interno. 

Permite generar vms con mas de una placa de redes y varios discos attacheados. Al tener valores por default para varios parámetros, podría extenderse con mas funcionalidades sin modifcar los códigos que ya lo estén usando.

# Parametros validos

Un objeto de tipo complex_instance espera tenga los siguientes valodres
* **name:**        string nombre de la maquina virtual
* **image:**       string La imagen base de sistema operativo
* **flavor:**      string El nombre del flavor asignado, el mismo defnie las caracteristicas (ram cpu etc)
* **keypair:**     string El nombre del keypair previamente subido a openstack que sera asignado en la vm  
* **network_list:**(optional)[string,...,string] El nombre de las redes que tendra asignadas, el minimo es cero []
* **disk_list:**   (optional){string:number,string:number...] Una lista de nombres de disco y su tamaño expresado en Gygabytes, el minimo de discos es cero({}), Ej: {"uno": 3 , "dos", 28}


# Uso del modulo

Para utilizar el modulo previamente mencionado, basta con un simple archivo como el siguiente y luego ejecutar los siguientes comandos


```bash
terraform init
terraform validate
terraform plan -out=plan
terraform apply plan
```

Monitoreo

```bash
watch -d -n 1 "date; openstack server list | grep -i mr-test ; echo ----- ; openstack volume list | grep mr-test"
``` 


En el siguiente ejemplo se se puede observar como se hicieron pruebas con gran cantidad de discos y no se observarons inconvenientes.


### main.tf
```yaml
module "instancia_1" {
  source = "../complex_instance"

  # Para crear multiples instancias
  # count   = 2
  # name    = "mr-test-module-node-${count.index}"
  # Para crear una instancia
  name    = "mr-test-module"

  keypair = "mrinaldi"

  image  = "CentOS7.9-V1.0"
  flavor = "CPU2RAM4096HD10GB"

  # network_list = []                # Ninguna red
  network_list = ["n1"]              # Una red
  # network_list = ["n1", "n1" ....] # Mas de una red

  network_fixed_ip = [] # Ips dinamicas
  # network_fixed_ip = ["10.30.188.xx"]                 # Misma cantidad de ips que placas de red
  # network_fixed_ip = ["10.30.188.xx", "10.30.188.yy"] # Misma cantidad de ips que placas de red
  # network_fixed_ip_list = ["10.30.188.xx", ""] " Una ip estatica, una dinamica



  # Ningun disco extra
  # disk_list = {} 
  disk_list = {
    "a" : 1,
    "b" : 2,
    "c" : 1,
    "d" : 3,
    "e" : 1,
    "f" : 2,
    "g" : 1,
    "h" : 3,
    "i" : 4,
    "j" : 2,
    "k" : 1,
    "l" : 5,
  }

}


output "instancia_1_info" {
  value = module.instancia_1
}
```