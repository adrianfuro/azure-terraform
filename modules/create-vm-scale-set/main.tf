variable "location" {}
variable "rg-name" {}
variable "subnet-id" {}
variable "backend_address_pool_id" {}
# variable "instance-count" {}
variable "azurerm_virtual_machine_scale_set" {
  default = "VMS-Scale"
  type = string
}

resource "azurerm_virtual_machine_scale_set" "scale-set" {
  name                = var.azurerm_virtual_machine_scale_set
  location            = var.location
  resource_group_name = var.rg-name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_B1S"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = "ubuntu"
    admin_password       = "Atos1234!"
    #custom_data          = file("./tomcat.conf")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = var.subnet-id
      load_balancer_backend_address_pool_ids = [var.backend_address_pool_id]
      primary                                = true
    }
  }

  #tags = var.tags

}