variable "location" {}
variable "rg-name" {}
variable "subnet-id" {}
variable "backend_address_pool_id" {}
# variable "instance-count" {}
variable "azurerm_virtual_machine_scale_set" {
  default = "VMS-Scale"
  type = string
}

# resource "azurerm_linux_virtual_machine_scale_set" "scale-set" {
#   name                = "exampleset"
#   location            = var.location
#   resource_group_name = var.rg-name
#   upgrade_mode        = "Manual"
#   sku                 = "Standard_F2"
#   instances           = var.instance-count
#   admin_username      = "ubuntu"

#   admin_ssh_key {
#     username   = "ubuntu"
#     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFHHKP0Cb86mR0uWKxXTpzE6WkVidCyUL2eoRBXGTKrjObLcOlQAG7NdC5BoG+PQeWle4MufDliu+2r8riizJT7jxHLl7EBHi9iHKLolY1p4Mic0l5k3swThslBxfv5dhIG4uwFg54qQKYGPAc6QC9DPRBPpgONv5JYPg52CR9XjVY8YDT96Z3d+MV2YbAakm1HNgZiQyIGwyxCyM/smDfZV7l5GKUEX6whfYdMuAozKFNc0rtz59NRKtCb+8LMC2zEtfnt9PjB6NswMkA/VJPn7OiSRDZPwIUZGA7Mihc+A7kJqOkqC730evgL+U7p4DKUxOk3TjUh4iBia8wJ+ImkO5sULyUxC5Pu9GOnszvnOrWRGlEBEuxrXEdo0mFgOTWlruXt2Z/FeL8PDosLtZTr22uuFOAPBmP0G9pbDGwoUASIpEN2suJJFBU9dJX5umDxrbJTZkJgo8PdbSCkN5P0zGxrxlFMGcoz+0XnTL8QutOG8r+Zd55kr3bL/dwiQk= ubuntu@DESKTOP-9D634I2"
#   }

#   network_interface {
#     name    = "TestNetworkProfile"
#     primary = true

#     ip_configuration {
#       name      = "TestIPConfiguration"
#       primary   = true
#       subnet_id = var.subnet-id
#     }
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   lifecycle {
#     ignore_changes = ["instances"]
#   }
# }

resource "azurerm_virtual_machine_scale_set" "scale-set" {
  name                = var.azurerm_virtual_machine_scale_set
  location            = var.location
  resource_group_name = var.rg-name
  upgrade_policy_mode = "Manual"

  #zones = local.zones

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