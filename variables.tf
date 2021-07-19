variable "prefix" {
  description = "A unique prefix used to prepend resource names"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "eastus2"
}