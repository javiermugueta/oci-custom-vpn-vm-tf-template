// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key      = "${var.private_key}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}
