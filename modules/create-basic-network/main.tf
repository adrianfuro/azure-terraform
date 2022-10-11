variable "vnet-name" {}
variable "nic-name" {}
variable "subnet-name" {}
variable "location" {}
variable "rg-name" {}
variable "nsg-name" {} 


resource "azurerm_virtual_network" "tf-vnet" {
  name = var.vnet-name
  address_space = [ "10.0.0.0/16" ]
  location = var.location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet" "tf-subnet" {
  name = var.subnet-name
  resource_group_name = var.rg-name
  virtual_network_name = var.vnet-name
  address_prefixes = [ "10.0.1.0/24" ]
  depends_on = [
    azurerm_virtual_network.tf-vnet
  ]
}

resource "azurerm_public_ip" "pip" {
  name = "pip"
  location = var.location
  resource_group_name = var.rg-name
  allocation_method = "Static"
  #sku = "Basic"
}


resource   "azurerm_network_interface"   "myvm1nic"   { 
   name   =   var.nic-name 
   location   =   var.location 
   resource_group_name   =   var.rg-name 
   depends_on = [
     azurerm_subnet.tf-subnet
   ]

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =   azurerm_subnet.tf-subnet.id
     private_ip_address_allocation   =   "Dynamic" 
     #public_ip_address_id   =   azurerm_public_ip.vm1-pip1.id
   } 
 }

 resource "azurerm_network_security_group" "example" {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = var.rg-name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "pip-id" {
    value = azurerm_public_ip.pip.id
}

output "subnet_id" {
    value = azurerm_subnet.tf-subnet.id
}