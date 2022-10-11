variable "location" {}
variable "rg-name" {}
variable "lb-name" {}
variable "pip-id" {}
variable "application_port" {
  default=80
  type=number
}

resource "azurerm_lb" "lb" {
 name                = var.lb-name
 location            = var.location
 resource_group_name = var.rg-name

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   public_ip_address_id = var.pip-id
 }
}

resource "azurerm_lb_backend_address_pool" "lb" {
 #resource_group_name = var.rg-name
 loadbalancer_id     = azurerm_lb.lb.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb" {
 #resource_group_name = var.rg-name
 loadbalancer_id     = azurerm_lb.lb.id
 name                = "ssh-running-probe"
 port                = var.application_port
}

resource "azurerm_lb_rule" "lb" {
   #resource_group_name            = var.rg-name
   loadbalancer_id                = azurerm_lb.lb.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.lb.id ]
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = azurerm_lb_probe.lb.id
}


output "bpepool" {
  value = azurerm_lb_backend_address_pool.lb.id
}