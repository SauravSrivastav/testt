# Get current Subscription
 data "azurerm_subscription" "current" {}

# Get current Client
data "azuread_client_config" "current" {}

# We'll need the Application Id of the Azure Kubernetes Service AAD Server.
data "azuread_service_principal" "aks_aad_server" {
 display_name = "Azure Kubernetes Service AAD Server"
}

# We'll need the Application Id of the Service Principal which will used for kubectl and helm authetication .
data "azuread_application" "spterraform" {
  display_name = var.terraform_sp_name
}

# We'll need the Application Id of the Service Principal which will used to manage azure resources line private dns and certificates .
data "azuread_application" "spcluster" {
  display_name = var.cluster_sp_name
}

# This is an existing RG in Azure, where we will create all the resources like AKS, NAT Gateway, Vnets etc.
data "azurerm_resource_group" "apimrg" {
  name = var.apimrg_name

}
# This is an existing RG and Vnet name in the RG which is used for peering
data "azurerm_virtual_network" "apimvnet" {
  name                = var.apimvnet_name
  resource_group_name = var.apimrg_name
}
# This is an existing Public IP Prefix that we are using in NAT Gateway
data "azurerm_public_ip_prefix" "public_ip_prefix" {
  name                = var.publicipprefix_name
  resource_group_name = var.apimrg_name
}

# This is an Existing Log Analytic Workspace that we are using to collect AKS logs
data "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.loganalytics_name
  resource_group_name = var.loganalytics_rg
}
