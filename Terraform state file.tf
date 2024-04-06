provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "terraformstate123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "testing"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

terraform {
  backend "azurerm" {
    resource_group_name   = azurerm_resource_group.example.name
    storage_account_name  = azurerm_storage_account.example.name
    container_name       = azurerm_storage_container.example.name
    key                  = "terraform.tfstate"
  }
}
