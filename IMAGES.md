# UBUNTU 20-FOCAL



| req |desc|
|-----|----| 
|file | focal-server-cloudimg-amd64.img | 
|url  |https://cloud-images.ubuntu.com/focal/20211118/focal-server-cloudimg-amd64|
|CPU  |>= 1 |
|RAM  |>= 128|
|BASE_DISK | >= 2.2gb|

# DEBIAN 11-BULLSEYE



| req |desc|
|-----|----| 
| file | debian-11-generic-amd64-20211011-792.qcow2 <br> debian-11-genericcloud-amd64-20211011-792.qcow2| 
|url (generic / genericcloud)  | https://cdimage.debian.org/cdimage/cloud/bullseye/20211011-792/debian-11-generic-amd64-20211011-792.qcow2 <br> https://cloud.debian.org/images/cloud/bullseye/20211011-792/debian-11-genericcloud-amd64-20211011-792.qcow2 <br>|
|CPU  |>= 1 |
|RAM  |>= 128|
|BASE_DISK | >= 2GB |


# DEBIAN 10- buster



| req |desc|
|-----|----| 
| file| debian-10-generic-amd64-20211011-792.qcow2 <br>debian-10-genericcloud-amd64-20211011-792.qcow2 | 
|url (generic/genericcloud)  | https://cdimage.debian.org/cdimage/cloud/buster/20211011-792/debian-10-generic-amd64-20211011-792.qcow2 <br> https://cloud.debian.org/images/cloud/buster/20211011-792/debian-10-genericcloud-amd64-20211011-792.qcow2 |
|CPU  |>= 1 |
|RAM  |>= 128|
|BASE_DISK | >= 2GB |

# CENTOS

| req |desc|
|-----|----| 
|file |CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2|
|url  |https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20210603.0.x86_64.qcow2|
|CPU  |>= 2 |
|RAM  |>= 384 |
|BASE_DISK | >= 20gb|


# CIRROS

| req |desc|
|-----|----| 
|file | cirros-0.5.2-x86_64-disk.img | 
|url  |https://download.cirros-cloud.net/0.5.2/cirros-0.5.2-x86_64-disk.img|
|CPU  |>= 1 |
|RAM  |>= 128|
|BASE_DISK | >= 128mb|




# KOLLA VALID KERNEL

Se pueden descargar imagenes generic(kernel generic) y genericcloud(kernel cloud) sus kernel no son iguales

apt-get install linux-image-generic-lts-wily
