// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.
#
data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = "${var.adnumber}"
}
#
resource "oci_core_vcn" "vpnvcn" {
  cidr_block     = "${var.vpnvcncidr}"
  compartment_id = "${var.compartmentocid}"
  display_name   = "${var.role}vpnvcn"
  dns_label      = "${var.role}vpnvcn"
}
#
resource "oci_core_internet_gateway" "igw" {
  compartment_id = "${var.compartmentocid}"
  display_name   = "${var.role}-igw"
  vcn_id         = "${oci_core_vcn.vpnvcn.id}"
}
resource "oci_core_subnet" "vpnsubnet" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  cidr_block          = "${var.vpnvcncidr}"
  display_name        = "${var.role}vpnsubnet"
  dns_label           = "${var.role}vpnsubnet"
  compartment_id      = "${var.compartmentocid}"
  vcn_id              = "${oci_core_vcn.vpnvcn.id}"
  security_list_ids   = ["${oci_core_security_list.vpnseclist.id}"]
  route_table_id      = "${oci_core_route_table.vpnroute.id}"
  prohibit_public_ip_on_vnic = false
}
#
resource "oci_core_instance" "vpninstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartmentocid}"
  display_name        = "${var.role}-vpninstance"
  shape               = "${var.imageshape}"
  source_details {
    source_type = "image"
    source_id   = "${var.vmimageocid}"
  }
  #
  create_vnic_details {
    assign_public_ip = false
    display_name     = "${var.role}-vnic"
    subnet_id        = "${oci_core_subnet.vpnsubnet.id}"
    hostname_label   = "${var.role}-vpninstance"
    private_ip = "${var.myvpnprivateip}"
    skip_source_dest_check = "true"
  }
  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
  #
  extended_metadata = {
    user_data = "${var.metadata}"
  }
}
# Gets a list of VNIC attachments on the instance
data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = "${var.compartmentocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.vpninstance.id}"
}
# Gets the OCID of the VNIC
data "oci_core_vnic" "instance_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
}
# Gets a list of private IPs on the first VNIC
data "oci_core_private_ips" "private_ip" {
  vnic_id = "${data.oci_core_vnic.instance_vnic.vnic_id}"
}
#
resource "oci_core_public_ip" "reserved_public_ip_assigned" {
  compartment_id = "${var.compartmentocid}"
  display_name   = "${var.role}-vpnreservedip"
  lifetime       = "RESERVED"
  private_ip_id  = "${data.oci_core_private_ips.private_ip.private_ips[0].id}"
}
output "myvpnpublic" {
  value = "${oci_core_public_ip.reserved_public_ip_assigned.ip_address}"
}
output "myvpnprivate" {
  value = "${data.oci_core_private_ips.private_ip.id}"
}
#
resource "oci_core_route_table" "vpnroute" {
  compartment_id = "${var.compartmentocid}"
  vcn_id         = "${oci_core_vcn.vpnvcn.id}"
  display_name   = "${var.role}-vpnroute"
  /*route_rules {
    destination       = "${var.yournetwork}"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${data.oci_core_private_ips.private_ip.id}"
  }*/
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.igw.id}"
  }
}
#
resource "oci_core_security_list" "vpnseclist" {
  compartment_id = "${var.compartmentocid}"
  display_name   = "${var.role}-vpnseclist"
  vcn_id         = "${oci_core_vcn.vpnvcn.id}"
  // Allow all outbound requests
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules {
    protocol = "all"
    source   = "${var.myvpnsubnet}"
  }
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}