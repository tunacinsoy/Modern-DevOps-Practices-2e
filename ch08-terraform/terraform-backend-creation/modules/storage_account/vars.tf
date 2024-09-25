variable "name" {
  type        = string
  description = "Storage Account Name"
}

variable "resource_group_name" {
  type = string
  description = "Resource Group Name that will contain Storage Account"
}

variable "location" {
  type        = string
  description = "Storage Account Location"
}

variable "account_tier" {
  type = string
  description = "Type of Storage Account"
  default = "Standard"
}

variable "account_replication_type" {
  type = string
  description = "Account Replication for Data Redundancy"
  default = "LRS"
}
