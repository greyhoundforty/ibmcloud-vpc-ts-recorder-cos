module "add_rules_to_default_vpc_security_group" {
  depends_on                   = [ibm_is_vpc.demo]
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.6.2"
  add_ibm_cloud_internal_rules = true
  use_existing_security_group  = true
  existing_security_group_name = "${local.prefix}-default-sg"
  security_group_rules = [
    {
      name      = "allow-ts-cidr-all-inbound"
      direction = "inbound"
      remote    = "100.64.0.0/10"
    },
    {
      name      = "allow-icmp-inbound"
      direction = "inbound"
      icmp = {
        type = 8
      }
      remote = "0.0.0.0/0"
    }
  ]
  tags = local.tags
}