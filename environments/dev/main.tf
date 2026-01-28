provider "azurerm" {
  features {}
}

module "rg" {
  source   = "../../modules/resource-group"
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../modules/network"
  rg_name             = module.rg.name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.vnet_cidr
  system_subnet_cidr  = var.system_subnet_cidr
  user_subnet_cidr    = var.user_subnet_cidr
  tags                = var.tags
}

module "monitoring" {
  source   = "../../modules/monitoring"
  rg_name = module.rg.name
  location = var.location
}

module "acr" {
  source   = "../../modules/acr"
  rg_name = module.rg.name
  location = var.location
  name     = var.acr_name
  tags     = var.tags
}

module "aks" {
  source             = "../../modules/aks"
  rg_name            = module.rg.name
  location           = var.location
  name               = var.aks_name
  system_subnet_id   = module.network.system_subnet_id
  user_subnet_id     = module.network.user_subnet_id
  law_id             = module.monitoring.law_id
  acr_id             = module.acr.id
  tags               = var.tags
}
