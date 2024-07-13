variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "app_id" {
  type        = string
  description = "Azure Service Principal appId"
}

variable "password" {
  type        = string
  description = "Azure Service Principal Password"
  sensitive   = true
}

variable "tenant" {
  type        = string
  description = "Azure Tenant ID"
}

variable "rg_name" {
  type        = string
  description = "Resource Group Name"
}

variable "rg_location" {
  type        = string
  description = "Resource Group Location"
}
