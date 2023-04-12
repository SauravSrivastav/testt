# Azure Location
variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
}

# Azure AKS Environment Name
variable "environment" {
  type        = string
  description = "This variable defines the Environment"
}

#domain for certificate creation
variable "domain" {
  type        = string
  description = "This variable defines the Domain"
}

# network profile
variable "dns_service_ip" {
  description = "this the dns service ip for the AKS cluster"
}

variable "service_cidr" {
  description = "this is the service cidr for the AKS cluster"
}

###################################################################### AKS Input Variables ##################################################################

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
}

# Admin name after SSH into Linux VMs using Private key
variable "admin_name" {
  description = "Default nodepool name"
}

# AKS admin group in Azure AD
variable "azuread_group_aks_administrators_id" {
  description = "aks cluster admin griup in ad"
}

#Application id provided to terraform to connect to azure and create resource using kubetctl and helm
variable "terraform_sp_name" {
  description = "terraform"
}

# We'll need the Application Id of the Service Principal which will used to manage azure resources line private dns and certificates .

variable "cluster_sp_name" {
  description = "terraform"
}


variable "terraform_sp_scrt" {
  description = "Client Secret of service principal"
}

variable "cluster_sp_scrt" {
  description = "Client Secret of service principal which can change dns entries for cert manager"
}

# variable for env and nodepool segregatation
variable "env_prefix" {
  description = " This we will be using everywhere for segregatation"
}

# variable used for segregation of eng api applications
variable "eng_prefix" {
  description = " This we will be using everywhere for segregatation"
}

# variable used for segregation of payments api applications
variable "pay_prefix" {
  description = " This we will be using everywhere for segregatation"
}

# variable used for segregation of web applications
variable "web_prefix" {
  description = " This we will be using everywhere for segregatation"
}

######################################################## K8s System Nodepool VM size and Name and K8s Version ##########################################################################

# K8s Version for both Master and Worker Nodes
variable "kubernetes_version" {
  description = "This variable defines kubernetes verion for both Master and Worker Nodes"
}

# Default System Nodepool VM size SKU
variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
}

# Default Sysytem nodepool name
variable "sysytem_nodepool_name" {
  description = "Default nodepool name"
}

# Default VNet name which will get created alongwith with AKS Cluster
variable "vnet_address_space" {
  description = "Default VNet name which will get created alongwith with AKS Cluster"
}

# Default first subnet name which will get created alongwith with AKS Cluster
variable "subnet_address_space" {
  description = "Default first subnet name which will get created alongwith with AKS Cluster"
}

# Default second subnet name which will get created alongwith with AKS Cluster
variable "subnet_address_space1" {
  description = "Default subnet name which will get created alongwith with AKS Cluster"
}

########################################################## Default Azure Resource Group  Resources###########################################################################

# This is the RG where all are resources are either created or getting imported
variable "apimrg_name" {
  description = "apim resource group name"
}

# public_ip_prefix from Azure RG
variable "publicipprefix_name" {
  description = "Public IP Prefix"
}

# This VNet is used for Peering which was created and was present in Azure RG
variable "apimvnet_name" {
  description = "apim resource group name"
}

# This is log Ananlytic Workspace which is already present in the Azure but in diff RG
variable "loganalytics_name" {
  description = "loganalytics name"
}

# This is log Ananlytic Workspace RG which is already present in the Azure
variable "loganalytics_rg" {
  description = "loganalytics name"
}

######################################################## K8s Additional  and  default_node_poolNodepool Creation ##########################################################################

# this is default availability zone for default sysytem nodepool
variable "default_availability_zones" {
  description = "this is default availability zone for default sysytem nodepool"
}

# this is a default max count for sysytem nodepool
variable "default_max_count_system" {
  description = "this is a default max count for sysytem nodepool"
}

# this is a default min count for sysytem nodepool
variable "default_min_count_system" {
  description = "this is a default min count for sysytem nodepool"
}

# this is defualt os disk size for the system nodepool
variable "default_os_disk_size_gb" {
  description = "this is defualt os disk size for the system nodepool"
}

variable "eng_namespace_names" {
  type        = list(string)
  description = "List of namespace names for the eng layer"
}

variable "clusterip_web" {
  description = "Ingress CLuster IP for Web"
}

variable "clusterip_eng" {
  description = "Ingress CLuster IP for Eng"
}

// variable "pay_namespace_names" {
//   type        = list(string)
//   description = "List of namespace names for the pay layer"
// }

variable "web_namespace_names" {
  type        = list(string)
  description = "List of namespace names for the web layer"
}

variable "az_aks_additional_node_pools" {
  type = map(object({
    node_count                     = number
    name                           = string
    mode                           = string
    vm_size                        = string
    node_taints                    = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    max_pods                       = number
    os_disk_size_gb                = number
    labels                         = map(string)
    availability_zones             = list(string)
  }))
}
