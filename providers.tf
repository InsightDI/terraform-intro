terraform {
  required_version = "~> 1.0.2"

  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "2.68.0"
    }
  }

  # backend "azurerm" {
  #   use_azuread_auth     = true
  #   storage_account_name = "YOURSTORAGEACCOUNT"
  #   container_name       = "YOURCONTAINERNAME"
  #   key                  = "terraform.tfstate"
  # }

}

provider "azurerm" {
  features {}
}