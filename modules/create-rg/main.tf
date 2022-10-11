variable "name" {}
variable "location" {}

resource   "azurerm_resource_group"   "rg"   { 
   name   =   var.name 
   location   =   var.location
 } 

output "rgname" {
  description = "Resource group name"
  value = azurerm_resource_group.rg.name
}