resource "ibm_is_vpc" "demo" {
  name                        = "${local.prefix}-vpc"
  resource_group              = module.resource_group.resource_group_id
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${local.prefix}-default-acl"
  default_security_group_name = "${local.prefix}-default-sg"
  default_routing_table_name  = "${local.prefix}-default-rt"
  tags                        = local.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "ibm_is_public_gateway" "demo" {
  name           = "${local.prefix}-pubgw-z1"
  resource_group = module.resource_group.resource_group_id
  vpc            = ibm_is_vpc.demo.id
  zone           = local.vpc_zones[0].zone
  tags           = local.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "ibm_is_subnet" "demo" {
  name                     = "${local.prefix}-subnet-z1"
  resource_group           = var.resource_group_id
  vpc                      = ibm_is_vpc.demo.id
  zone                     = local.vpc_zones[0].zone
  total_ipv4_address_count = "32"
  tags                     = local.tags
  public_gateway           = ibm_is_public_gateway.demo.id
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}