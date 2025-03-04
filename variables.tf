variable "ibmcloud_api_key" {
    description = "IBM Cloud API key"
    type        = string
    sensitive = true
}

variable "tailscale_api_key" {
  description = "The Tailscale API key"
  type        = string
  sensitive   = true
}

variable "tailscale_organization" {
  description = "The Tailscale tailnet Organization name. Can be found in the Tailscale admin console > Settings > General."
  type        = string
}

variable "prefix" {
  description = "Prefix to add to all deployed resources"
  type        = string
}

variable "region" {
  description = "The region to create the VPC in"
  type        = string
}


variable "default_address_prefix" {
  description = "The default address prefix for the VPC"
  type        = string
  default     = "auto"
}

variable "instance_profile" {
  description = "The name of the instance profile to use for the compute instances."
  type        = string
  default     = "cx2-2x4"
}

variable "base_image" {
  description = "The name of the base image to use for the compute instances."
  type        = string
  default     = "ibm-ubuntu-22-04-4-minimal-amd64-3"
}

variable "existing_resource_group" {
  description = "The name of an existing resource group to use, if not provided a new one will be created."
  type        = string
  default     = ""
}

variable "existing_ssh_key" {
  description = "The name of an existing SSH key to use, if not provided a new one will be created."
  type        = string
  default     = ""
}