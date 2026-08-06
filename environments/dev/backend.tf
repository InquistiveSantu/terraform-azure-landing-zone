terraform {
  backend "azurerm" {

    resource_group_name  = "rg-dev-Landing-Zone-project-1"
    storage_account_name = "state0files0stg0dev1"
    container_name       = "devtfstate"
    key                  = "dev.tfstate"
  }
  required_providers {
    azurerm = {

      source  = "hashicorp/azurerm"
      version = "5.0.1"
    }

  }

}