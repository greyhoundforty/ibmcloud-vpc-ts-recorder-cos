resource "ibm_is_virtual_network_interface" "recorder" {
  allow_ip_spoofing         = true
  auto_delete               = false
  enable_infrastructure_nat = true
  name                      = "${local.prefix}-recorder-vnic"
  subnet                    = ibm_is_subnet.demo.id
  resource_group            = module.resource_group.resource_group_id
  security_groups           = [ibm_is_vpc.demo.default_security_group]
  tags                      = local.tags
}

resource "ibm_is_instance" "recorder" {
  name           = "${local.prefix}-recorder-instance"
  vpc            = ibm_is_vpc.demo.id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = module.resource_group.resource_group_id
  metadata_service {
    enabled            = true
    protocol           = "https"
    response_hop_limit = 5
  }

  user_data = templatefile("./ts-instance.yaml", {
    tailscale_tailnet_key = tailscale_tailnet_key.lab_key.key
  })

  boot_volume {
    auto_delete_volume = true
  }

  primary_network_attachment {
    name = "${local.prefix}-eth0"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.recorder.id
    }
  }

  zone = local.vpc_zones[0].zone
  keys = local.ssh_key_ids
  tags = local.tags
}
