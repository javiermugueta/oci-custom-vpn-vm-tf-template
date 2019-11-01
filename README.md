# oci custom vpm vm terraform template

## purpose
Provission a vpn headend with Libreswan in an Oracle compute VM

## steps
### clone stuff
```
git clone https://github.com/javiermugueta/oci-custom-vpn-vm-tf-template
```
### edit files
Following files mut be configured
#### vars.env.sh
Put rerraform environment variables there
#### vars.networking.sh
Design networking in collaboration with your peer and set values appropriatelly
#### vars.oci.sh
The OCI information needed and other stuff to be created previously
### run script
```
./run.create.sh
```
### my public IP
The public IP of the VM is shown after terraform script execution. Grab it for later!
### ssh to VM
ssh to vm with the private key you provided in vars.oci.sh
### sudo
sudo -i
### final steps in conf
Edit myvpn.comf and myvpn.secrets with the public IP created


