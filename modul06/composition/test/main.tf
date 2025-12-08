resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}


module "network" {
  source             = "../../modules/network"
  rgname             = azurerm_resource_group.rg.name
  location           = var.location
  environment        = var.environment
  name_prefix        = var.name_prefix
  vnet_address_space = var.vnet_address_space
  subnet_prefixes    = var.subnet_prefixes
  ssh_source_ip      = var.ssh_source_ip
  tags               = var.tags
}

module "compute" {
  source         = "../../modules/compute"
  rgname         = azurerm_resource_group.rg.name
  location       = var.location
  environment    = var.environment
  name_prefix    = var.name_prefix
  subnet_id      = module.network.subnet_id
  vm_size        = var.vm_size
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  tags           = var.tags
}

output "nginx_url" {
  value       = module.compute.nginx_url
  description = "Public URL of NGINX in dev environment"
}
