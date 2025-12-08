variable "location" {
  type    = string
  default = "westeurope"
}

variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_prefixes" {
  type = list(string)
}

variable "ssh_source_ip" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "subscription_id" {
  type = string
}
