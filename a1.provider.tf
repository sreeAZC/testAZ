provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
tenant_id = var.tenant_id
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false
      ##it will ensure when the vm is destro disk is not delete. 

    }
    backend "azurerm" {
        resource_group_name = "AZT-RG1"
        storage_account_name = "aznewterraformtfstate"
        container = "azc"
        key = "ATS"
    }
  }
  alias = "provider2-westus"
  #cleintid="XXXXX"
  ##clientsecret = "YYYY"
  #environment = "us2"
  #"subscription_id"="1221212"
}
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #source = "hashicorp/aws"
      #version = "2.40.0"
    }
  }
}