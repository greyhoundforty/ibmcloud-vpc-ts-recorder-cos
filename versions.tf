terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.76.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.18.0"
    }
  }
}
