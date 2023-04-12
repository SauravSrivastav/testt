
/*------------------------AKS CLuster Creation ----------------------
         |  Code Written on 20/10/2022
         |  Author:  Anil Shivaram & Saurav Srivastav
         |  Language: HCL
         |
         |  Code Modified On:
         |
         |  Purpose:  Provision AKS, VNet and  NAT Gateway with Terraform
         |
         *--------------------------------------------------------------------*/
# Terraform Settings Block

terraform {
  # 1. Required Version Terraform
  required_version = ">= 0.13"

  # 2. Required Terraform Providers
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
     helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Terraform State Storage to Azure Storage Container
  backend "azurerm" {
  }
}

# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  skip_provider_registration = "true"
  features {
  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {
}

# Configuring the kubernetes provider
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)

  # Using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      data.azuread_service_principal.aks_aad_server.application_id, # Application Id of the Azure Kubernetes Service AAD Server.
      "--client-id",
      data.azuread_application.spterraform.application_id, // Application Id of the Service Principal we'll create via terraform.
      "--client-secret",
      var.terraform_sp_scrt, // The Service Principal's secret.
      "-t",
      data.azurerm_subscription.current.tenant_id, // The AAD Tenant Id.
      "-l",
      "spn" // Login using a Service Principal..
    ]
  }
}
provider "helm" {
  kubernetes {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)

  # Using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      data.azuread_service_principal.aks_aad_server.application_id, # Application Id of the Azure Kubernetes Service AAD Server.
      "--client-id",
      data.azuread_application.spterraform.application_id, // Application Id of the Service Principal we'll create via terraform.
      "--client-secret",
      var.terraform_sp_scrt, // The Service Principal's secret.
      "-t",
      data.azurerm_subscription.current.tenant_id, // The AAD Tenant Id.
      "-l",
      "spn" // Login using a Service Principal..
    ]
  }
}
}





