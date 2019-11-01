# oci custom vpm vm terraform template

## purpose
Provission a vpn headend with Libreswan in an Oracle compute VM

## steps
### 1.clone stuff
```
git clone https://github.com/javiermugueta/oci-custom-vpn-vm-tf-template
```

### 2.edit files
Following files mut be configured

#### 2.1.vars.env.sh
Put rerraform environment variables there

#### 2.2.vars.networking.sh
Design networking in collaboration with your peer and set values appropriatelly

#### 2.3.vars.oci.sh
The OCI information needed and other stuff to be created previously

### 3.run script
```
./run.create.sh
```

### 4.my public IP
The public IP of the VM is shown after terraform script execution.<br>
Grab it for later!

### 5.ssh to VM
ssh to vm with the private key you provided in vars.oci.sh

### 6.sudo
sudo -i

### 7.final steps in conf
Edit /etc/ipsec.d/myvpn.cof and /etc/ipsec.d/myvpn.secrets with the public IP created

### 8.start to see if tunnel starts up
Make a collaboration meeting with your peer and see what happens.<br>
Good luck!!!!<br>
This command may help:<br>
```
systemctl restart ipsec.service
ipsec auto --add myvpn
ipsec auto --up myvpn
ipsec status
ipsec barf
ipsec --help
```



