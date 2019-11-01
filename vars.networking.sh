# varibles used to create config files based in tunnel
#
# the preshared key agreed with the other side
psk="............"
#
# 
# left side (me/my)
my_vpn_private_ip="<the private ip I want the vpn vm to assign to, such as 10.250.128.10>"
my_vpn_public_ip="<assigned on creation, see tf output, change it later>"
my_vpn_subnet="<the subnet encriptions domain in my side, such 10.250.128.0/24>"
# right side (you/your)
your_vpn_public_ip="<put here the public IP assigned by the rigth peer>"
your_vpn_private_ip="<put here the private IP of the rigth peer>"
your_vpn_subnet="<the subnet encriptions domain in right side>"
#
# oci networking
#
my_vpn_vcn_cidr=<"the cidr of the virtual cloud network Is gonna be created such 10.250.0.0/16>"