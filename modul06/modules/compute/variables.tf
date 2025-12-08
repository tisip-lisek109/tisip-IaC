variable "rgname" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "environment" {
  type        = string
  description = "Environment tag"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID from network module"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type        = string
  description = "Path to SSH public key file"
}

variable "tags" {
  type    = map(string)
  default = {}
}
