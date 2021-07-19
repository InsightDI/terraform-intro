terraform {
  required_version = "~> YOURTERRAFORMVERSION"

  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "VERSION"
    }
  }

  # backend "azurerm" {
  #   use_azuread_auth     = true
  #   storage_account_name = "YOURSTORAGEACCOUNT"
  #   container_name       = "YOURCONTAINERNAME"
  #   key                  = "intro.tfstate"
  # }

}

provider "azurerm" {
  features {}
}
