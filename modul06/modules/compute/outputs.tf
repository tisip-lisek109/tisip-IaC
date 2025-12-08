
output "public_ip_address" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public IP of the VM"
}

output "nginx_url" {
  value       = "http://${azurerm_public_ip.pip.ip_address}"
  description = "URL to access NGINX"
}
