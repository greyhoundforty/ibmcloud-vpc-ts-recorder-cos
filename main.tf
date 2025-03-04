locals {
  prefix      = var.prefix != "" ? var.prefix : "${random_string.prefix.0.result}"
  ssh_key_ids = var.existing_ssh_key != "" ? [data.ibm_is_ssh_key.sshkey[0].id] : [ibm_is_ssh_key.generated_key[0].id]
  zones       = length(data.ibm_is_zones.regional.zones)
  vpc_zones = {
    for zone in range(local.zones) : zone => {
      zone = "${var.region}-${zone + 1}"
    }
  }
  deploy_timestamp = formatdate("YYYYMMDD-HHmm", time_static.deploy_time.rfc3339)

  tags = [
    "created_at:${local.deploy_timestamp}",
    "project:${local.prefix}",
    "region:${var.region}"
  ]
}

resource "time_static" "deploy_time" {
  # Leave triggers empty to prevent the timestamp from changing
  triggers = {}
}


# If no project prefix is defined, generate a random one 
resource "random_string" "prefix" {
  count   = var.prefix != "" ? 0 : 1
  length  = 4
  special = false
  numeric = false
  upper   = false
}


# If an existing resource group is provided, this module returns the ID, otherwise it creates a new one and returns the ID
module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.existing_resource_group == null ? "${local.prefix}-resource-group" : null
  existing_resource_group_name = var.existing_resource_group
}


resource "tls_private_key" "ssh" {
  count     = var.existing_ssh_key != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "generated_key" {
  count          = var.existing_ssh_key != "" ? 0 : 1
  name           = "${local.prefix}-${var.region}-sshkey"
  resource_group = module.resource_group.resource_group_id
  public_key     = tls_private_key.ssh.0.public_key_openssh
  tags           = local.tags
}


resource "tailscale_tailnet_key" "lab_key" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 3600
  description   = "Demo key for ${local.prefix}"
  tags          = ["tag:rst"]
}









