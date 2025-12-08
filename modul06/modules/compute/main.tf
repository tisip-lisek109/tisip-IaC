# Public IP
resource "azurerm_public_ip" "pip" {
  name                = "${var.name_prefix}-pip"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge({ environment = var.environment }, var.tags)
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.name_prefix}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = merge({ environment = var.environment }, var.tags)
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.name_prefix}-vm"
  location            = var.location
  resource_group_name = var.rgname
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  tags = merge({ environment = var.environment }, var.tags)
}
