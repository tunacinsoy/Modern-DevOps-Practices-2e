variable "name" {
  type        = string
  description = "Container Name"
}

variable "storage_account_name" {
  type = string
  description = "Storage Account Name that will store this container"
}

variable "container_access_type" {
  type = string
  description = "Container Access Type"
}
