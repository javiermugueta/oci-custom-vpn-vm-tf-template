#!/bin/bash
# 
# javier mugueta unzue | october 2019
#
# setting env variables
#
source vars.env.sh 
source vars.networking.sh 
source vars.oci.sh
#
# creating tf-tf-variables.tf
#
echo "variable \"tenancy_ocid\" {default = \""${tenancy_ocid}"\" }" > tf-variables.tf
echo "variable \"private_key_path\" {default = \""${private_key_path}"\" }" >> tf-variables.tf
echo "variable \"user_ocid\" {default = \""${user_ocid}"\" }" >> tf-variables.tf
echo "variable \"fingerprint\" {default = \""${fingerprint}"\" }" >> tf-variables.tf
echo "variable \"private_key\" {default = \""${private_key}"\" }" >> tf-variables.tf
echo "variable \"region\" {default = \""${region}"\" }" >> tf-variables.tf
echo "variable \"ssh_public_key\" {default = \""${ssh_public_key}"\" }" >> tf-variables.tf
echo "variable \"ssh_private_key\" {default = \""${ssh_private_key}"\" }" >> tf-variables.tf
echo "variable \"api_public_key\" {default = \""${api_public_key}"\" }" >> tf-variables.tf
#
echo "variable \"compartmentocid\" { default = \""${compartmentocid}"\"}" >> tf-variables.tf
echo "variable \"imageshape\" { default = \""${imageshape}"\"}" >> tf-variables.tf
echo "variable \"vmimageocid\" {default = \""${vmimageocid}"\" }" >> tf-variables.tf
echo "variable \"adnumber\" {default = \""${adnumber}"\" }" >> tf-variables.tf
#
echo "variable \"vpnvcncidr\" {default = \""${my_vpn_vcn_cidr}"\"}"  >> tf-variables.tf
echo "variable \"myvpnsubnet\" {default = \""${my_vpn_subnet}"\"}"  >> tf-variables.tf
echo "variable \"myvpnprivateip\"{default = \""${my_vpn_private_ip}"\"}"  >> tf-variables.tf
echo "variable \"myvpnpublicip\"{default = \""${my_vpn_public_ip}"\"}"  >> tf-variables.tf
echo "variable \"yourvpnprivateip\" {default = \""${your_vpn_private_ip}"\"}"  >> tf-variables.tf
echo "variable \"yourvpnpublicip\" {default = \""${your_vpn_public_ip}"\"}"  >> tf-variables.tf
echo "variable \"yournetwork\" {default = \""${your_vpn_subnet}"\"}"  >> tf-variables.tf
echo "variable \"role\" {default = \""${role}"\"}"  >> tf-variables.tf
#
# building myvpn.conf file
#
cat template.vpn > myvpn.conf
#
echo "  leftid="${my_vpn_public_ip} >> myvpn.conf
echo "  left="${my_vpn_private_ip} >> myvpn.conf
echo "  leftsourceip="${my_vpn_private_ip} >> myvpn.conf
echo "  leftsubnet="${my_vpn_subnet} >> myvpn.conf
echo "  right="${your_vpn_public_ip} >> myvpn.conf
echo "  rightid="${your_vpn_private_ip} >> myvpn.conf
echo "  rightsubnet="${your_vpn_subnet} >> myvpn.conf
#
# building myvpn.secrets file
#
echo "${myvpnprivateip} ${yourvpnpublicip} : PSK \"${psk}\"" > myvpn.secrets
echo "${myvpnpublicip} ${yourvpnpublicip} : PSK \"${psk}\"" >> myvpn.secrets
#
# creating cloud-init script
#
cat template.cloudinit.1 > tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
echo "cat <<EOF >> /etc/ipsec.d/myvpn.conf" >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
cat myvpn.conf >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
echo "EOF" >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
echo "cat <<EOF >> /etc/ipsec.d/myvpn.secrets" >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
cat myvpn.secrets >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script
echo "EOF" >> tmp.cloudinit.script 
echo " " >> tmp.cloudinit.script 
cat template.cloudinit.2 >> tmp.cloudinit.script 
#
base64 -e tmp.cloudinit.script tmp.cloudinit.encoded
metadata=$(tr -d '\r\n' < tmp.cloudinit.encoded)
echo "variable \"metadata\" {default = \""${metadata}"\" }" >> tf-variables.tf
#
# executing tf
#
echo
echo "Take a look to the following created files:"
echo "   tf.variables.tf"
echo "   tmp.cloudinit.script"
echo "   myvpn.conf"
echo "   myvpn.secrets"
echo
echo "If everything goes fine, the stuff will be created."
echo "Making changes to this setup may not work if they apply to the vm"
echo "because cloud-init script metadata can't be changed after creation."
echo "If that is the case destroy and recreate or make changes"
echo "in the cloud stuff."
echo
read -p "Hit Y to proceed or whatever to abandon cowardly: " myvar
if [ -z "$myvar" ]
then
    echo "booooh baaaaaah"
else
    if [ $myvar == "Y" ]
    then
        terraform apply -auto-approve 
    fi
fi
rm myvpn.conf
rm myvpn.secrets
rm tmp.cloudinit.encoded
rm tmp.cloudinit.script 
#