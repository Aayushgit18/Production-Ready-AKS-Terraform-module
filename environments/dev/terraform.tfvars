location            = "eastus"
rg_name             = "aks-dev-rg"
aks_name            = "aks-dev"
acr_name            = "acrdev12345"
vnet_name           = "aks-dev-vnet"
vnet_cidr           = ["10.0.0.0/8"]
system_subnet_cidr  = "10.1.0.0/16"
user_subnet_cidr    = "10.2.0.0/16"
tags = {
  environment = "dev"
  owner       = "platform"
}
