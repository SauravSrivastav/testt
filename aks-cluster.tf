resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${data.azurerm_resource_group.apimrg.name}-aks-cluster"
  location            = data.azurerm_resource_group.apimrg.location
  resource_group_name = data.azurerm_resource_group.apimrg.name
  dns_prefix          = "${data.azurerm_resource_group.apimrg.name}-cluster"
  kubernetes_version  = var.kubernetes_version
  node_resource_group = "${data.azurerm_resource_group.apimrg.name}-aks-nrg"
  local_account_disabled = true

  default_node_pool {
    name                 = var.sysytem_nodepool_name
    vm_size              = var.nodepool_vm_size
    orchestrator_version = var.kubernetes_version
    availability_zones   = var.default_availability_zones
    enable_auto_scaling  = true
    max_count            = var.default_max_count_system
    min_count            = var.default_min_count_system
    os_disk_size_gb      = var.default_os_disk_size_gb
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id       = azurerm_subnet.aks-default.id
    node_labels = {
      "nodepool-type" = var.sysytem_nodepool_name
      "environment"   = var.environment
    }
    tags = {
      "nodepool-type" = var.sysytem_nodepool_name
      "environment"   = var.environment
    }
  }

  # Add On Profiles
  addon_profile {
    azure_policy { enabled = true }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id
    }
  }

  # Linux Profile
  linux_profile {
    admin_username = var.admin_name
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = "172.18.0.1/16"
    service_cidr       = var.service_cidr
    load_balancer_sku  = "standard"
    outbound_type      = "userAssignedNATGateway"
    nat_gateway_profile {
      idle_timeout_in_minutes = 4
    }
  }
   depends_on            = [azurerm_subnet_nat_gateway_association.sn_cluster_nat_gw, azurerm_subnet_nat_gateway_association.sn1_cluster_nat_gw, azurerm_nat_gateway_public_ip_association.nat_ips, azurerm_virtual_network.aksvnet, azurerm_subnet.aks-default, azurerm_subnet.aks-default-1, azurerm_public_ip.publicip, azurerm_nat_gateway.gw_aks]


  # RBAC and Azure AD Integration Block
  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [var.azuread_group_aks_administrators_id]
      azure_rbac_enabled = false
    }
  }

  // # Identity (System Assigned or Service Principal)
  // service_principal {
  //   client_id     = data.azuread_application.spcluster.application_id
  //   client_secret = var.cluster_sp_scrt
  // }
  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }
  



  
  # We’ve to explicitly ignore changes being made to network_profile[0].nat_gateway_profile. If we don’t ignore the nat_gateway_profile.
  # Terraform will replace the entire AKS cluster every time we apply the project.
  lifecycle {
    ignore_changes = [
      network_profile[0].nat_gateway_profile
    ]
  }
  tags = {
    Environment = var.environment
  }
}



resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  for_each              = var.az_aks_additional_node_pools
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  name                  = each.value.name
  mode                  = each.value.mode
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  availability_zones    = each.value.availability_zones
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  node_taints           = each.value.node_taints
  node_labels           = each.value.labels
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  vnet_subnet_id        = azurerm_subnet.aks-default.id
}
