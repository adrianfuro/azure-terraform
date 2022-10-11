terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "rg" {
  source = "./modules/create-rg"

  name     = "tf-rg"
  location = "northeurope"
}

module "network" {
  source = "./modules/create-basic-network"

  vnet-name   = "tf-vnet"
  subnet-name = "tf-subnet"
  nic-name    = "nic1"
  location    = "northeurope"
  nsg-name    = "tf-nsg"
  rg-name     = module.rg.rgname
}

module "loadbalancer" {
  source = "./modules/create-lb"

  lb-name  = "tf-lb"
  location = "northeurope"
  rg-name  = module.rg.rgname
  pip-id = module.network.pip-id
}

module "scale-set" {
  source = "./modules/create-vm-scale-set"

  location            = "northeurope"
  rg-name = module.rg.rgname
  subnet-id = module.network.subnet_id
  backend_address_pool_id = module.loadbalancer.bpepool
}