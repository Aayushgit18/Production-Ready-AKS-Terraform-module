variable "rg_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }
variable "system_subnet_cidr" { type = string }
variable "user_subnet_cidr" { type = string }
variable "tags" { type = map(string) }
