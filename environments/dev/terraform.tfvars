location           = "eastus"
rg_name            = "aks-dev-rg"
aks_name           = "aks-dev"
acr_name           = "acrdevayu2026512"
vnet_name          = "aks-dev-vnet"
vnet_cidr          = ["10.0.0.0/8"]
system_subnet_cidr = "10.1.0.0/16"
user_subnet_cidr   = "10.2.0.0/16"
tags = {
  environment = "dev"
  owner       = "platform"
}
key_vault_name = "kv-aks-dev"
tenant_id      = "aac42910-b03a-44c1-b372-7cee5c67a2d5"
