#
# availability domain number from 1 to 3 (note some regions have only one ad)
adnumber="1"
#
# get the ocid of a previously created compartment and put here
compartmentocid="ocid1....."
#
# the image shape, change it if necessary
imageshape="VM.Standard2.1"
#
# the ocid of the vm image, change it appropriatelly depending on region and image, here som current values
#vmimageocid="ocid1.image.oc1.eu-zurich-1.aaaaaaaacku52lqvorlqunj34xxna73jm5tblrk7veqxkuejgda6mgjc5pma"
#region="eu-zurich-1"
vmimageocid="ocid1.image.oc1.eu-frankfurt-1.aaaaaaaajqghpxnszpnghz3um66jywaw5q3pudfw5qwwkyu24ef7lcsyjhsq"
region="eu-frankfurt-1"
#
# utilized for naming stuff
role="left"
#
# credentials for tf, get hte values from your environment and tenant
private_key_path="~/.oci/oci_api_key.pem"
tenancy_ocid="..."
user_ocid="o..."
fingerprint="..."
private_key="..."
ssh_public_key="..."
ssh_private_key="..."
api_public_key="..."
#