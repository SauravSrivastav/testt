# Azure Location for all the resources
location = "#{location}#"

# Azure Resource Group Name
resource_group_name = "#{resource_group_name}#"

# Azure AKS Environment Name
environment = "#{environment}#"

##Domain for certifcate requests
domain ="#{domain}#"

# network profile for AKS cluster
dns_service_ip = "#{dns_service_ip}#"

service_cidr = "#{service_cidr}#"

###################################################################### AKS Input Variables ####################################################################

# SSH Public Key for Linux VMs
ssh_public_key = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"

# Admin name after SSH into Linux VMs using Private key
admin_name = "#{admin_name}#"

# AKS admin group azure ad
azuread_group_aks_administrators_id= "#{azuread_group_aks_admin}#"

#Application id provided to terraform to connect to azure and create resource using kubetctl and helm
terraform_sp_name = "#{terraform_sp_name}#"

# We'll need the Application Id of the Service Principal which will used to manage azure resources line private dns and certificates
cluster_sp_name = "#{cluster_sp_name}#"



# variable for env and nodepool segregatation
env_prefix = "#{env_prefix}#"

# variable used for segregation of engine api applications
eng_prefix = "#{eng_prefix}#"

# variable used for segregation of payments api applications
pay_prefix = "#{pay_prefix}#"

# variable used for segregation of web applications
web_prefix = "#{web_prefix}#"

terraform_sp_scrt = "#{terraform_sp_scrt}#"

cluster_sp_scrt = "#{cluster_sp_scrt}#"

######################################################## K8s System Nodepool VM size and Name and K8s Version ##########################################################################

# K8s Version for both Master and Worker Nodes
kubernetes_version = "#{kubernetes_version}#"

# Default System Nodepool VM SKU
nodepool_vm_size = "#{nodepool_vm_size}#"

# System nodepool name
sysytem_nodepool_name = "#{sysytem_nodepool_name}#"

vnet_address_space = ["#{vnet_address_space1}#" ,"#{vnet_address_space2}#"]

subnet_address_space = ["#{subnet_address_space}#"]

subnet_address_space1 = ["#{subnet_address_space1}#"]

########################################################## Default Azure Resource Group Resources ###########################################################################

# This is the RG where all are resources are either created or getting imported
apimrg_name = "#{apimrg_name}#"

# public_ip_prefix from Azure RG
publicipprefix_name = "#{publicipprefix_name}#"

# This VNet is used for Peering which was created and was present in Azure RG
apimvnet_name = "#{apimvnet_name}#"

# This is log Ananlytic Workspace which is already present in the Azure but in diff RG
loganalytics_name = "#{loganalytics_name}#"

# This is log Ananlytic Workspace RG which is already present in the Azure
loganalytics_rg = "#{loganalytics_rg}#"

######################################################## K8s Additional Nodepool Creation ##########################################################################

#this is default availability zone for default sysytem nodepool
default_availability_zones = [1, 2, 3]

# this is a default max count for sysytem nodepool
default_max_count_system = "#{default_max_count_system}#"

# this is a default min count for sysytem nodepool
default_min_count_system = "#{default_min_count_system}#"

# this is defualt os disk size for the system nodepool
default_os_disk_size_gb = "#{default_os_disk_size_gb}#"

eng_namespace_names = ["guard","identity","notification","report","utility"]

web_namespace_names = ["webhooks","paymentlink"]

// pay_namespace_names = ["test1"]

clusterip_web = "#{clusterip_web}#"

clusterip_eng = "#{clusterip_eng}#"

# user nodepool variables
az_aks_additional_node_pools = {
  engpool = {
    node_count         = "#{eng_node_count}#"
    mode               = "#{eng_mode}#"
    name               = "#{eng_name}#"
    vm_size            = "#{eng_vm_size}#"
    availability_zones = ["1", "2"]
    node_taints = [
      "layer=eng:NoSchedule"
    ]
    labels = {
      layer : "eng"
    }
    cluster_auto_scaling           = "#{eng_cluster_auto_scaling}#"
    cluster_auto_scaling_min_count = "#{eng_cluster_auto_scaling_min_count}#"
    cluster_auto_scaling_max_count = "#{eng_cluster_auto_scaling_max_count}#"
    max_pods                       = "#{eng_max_pods}#"
    os_disk_size_gb                = "#{eng_os_disk_size_gb}#"
  }
  # paypool = {
  #   node_count         = 1
  #   name               = "paypool"
  #   mode               = "User"
  #   vm_size            = "Standard_B2ms"
  #   availability_zones = ["1", "2", "3"]
  #   node_taints = [
  #     "layer=pay:NoSchedule"
  #   ]
  #   labels = {
  #     layer : "pay"
  #   }
  #   cluster_auto_scaling           = false
  #   cluster_auto_scaling_min_count = null
  #   cluster_auto_scaling_max_count = null
  #   max_pods                       = 250
  #   os_disk_size_gb                = 128
  # }
  webpool = {
    node_count         = "#{eng_node_count}#"
    mode               = "#{eng_mode}#"
    name               = "#{web_name}#"
    vm_size            = "#{eng_vm_size}#"
    availability_zones = ["1", "2"]
    node_taints = [
      "layer=web:NoSchedule"
    ]
    labels = {
      layer : "web"
    }
    cluster_auto_scaling           = "#{eng_cluster_auto_scaling}#"
    cluster_auto_scaling_min_count = "#{eng_cluster_auto_scaling_min_count}#"
    cluster_auto_scaling_max_count = "#{eng_cluster_auto_scaling_max_count}#"
    max_pods                       = "#{eng_max_pods}#"
    os_disk_size_gb                = "#{eng_os_disk_size_gb}#"
  }
}

