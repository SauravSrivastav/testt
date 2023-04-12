# Create Azure VNet for AKS cluster
resource "azurerm_virtual_network" "aksvnet" {
  name                = "${var.env_prefix}-aks-vnet"
  location            = data.azurerm_resource_group.apimrg.location
  resource_group_name = data.azurerm_resource_group.apimrg.name
  address_space       = var.vnet_address_space
}

# Create a Subnet for AKS cluster
resource "azurerm_subnet" "aks-default" {
  name                 = "${var.env_prefix}-aks-snet"
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = data.azurerm_resource_group.apimrg.name
  address_prefixes     = var.subnet_address_space
  depends_on           = [azurerm_virtual_network.aksvnet]

}

# Create a Subnet for AKS cluster
resource "azurerm_subnet" "aks-default-1" {
  name                 = "${var.env_prefix}-svc-snet"
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = data.azurerm_resource_group.apimrg.name
  address_prefixes     = var.subnet_address_space1
  depends_on           = [azurerm_virtual_network.aksvnet]

}

# Peering b/w AKS Vnet and APIM Vnet
resource "azurerm_virtual_network_peering" "aks-apim-peer" {
  name                         = "${var.env_prefix}-apims-peer"
  resource_group_name          = data.azurerm_resource_group.apimrg.name
  virtual_network_name         = azurerm_virtual_network.aksvnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.apimvnet.id
  allow_virtual_network_access = true
  depends_on                   = [azurerm_subnet.aks-default, azurerm_subnet.aks-default-1]

}

# Peering b/w  APIM Vnet and AKS Vnet

resource "azurerm_virtual_network_peering" "apim-aks-peer" {
  name                      = "apims${var.env_prefix}-peer"
  resource_group_name       = data.azurerm_resource_group.apimrg.name
  virtual_network_name      = data.azurerm_virtual_network.apimvnet.name
  remote_virtual_network_id = azurerm_virtual_network.aksvnet.id
  allow_forwarded_traffic   = true
  depends_on                = [azurerm_virtual_network.aksvnet]

}
# Nat Gateway

# this is for Public IP address which got created in Public IP Prefixes

resource "azurerm_public_ip" "publicip" {
  # count                 = 1
  name                = "${var.env_prefix}-aks-pip1"
  location            = data.azurerm_resource_group.apimrg.location
  resource_group_name = data.azurerm_resource_group.apimrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  public_ip_prefix_id = data.azurerm_public_ip_prefix.public_ip_prefix.id
  depends_on           = [data.azurerm_public_ip_prefix.public_ip_prefix]
}

# Creating NAT Gateway
resource "azurerm_nat_gateway" "gw_aks" {
  name                    = "${var.env_prefix}-aks-ngw"
  resource_group_name     = data.azurerm_resource_group.apimrg.name
  location                = data.azurerm_resource_group.apimrg.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  # zones                   = ["1"]
  depends_on            = [azurerm_public_ip.publicip]
}

# Associating NAT Gateway with Public IP 
resource "azurerm_nat_gateway_public_ip_association" "nat_ips" {
  nat_gateway_id       = azurerm_nat_gateway.gw_aks.id
  public_ip_address_id = azurerm_public_ip.publicip.id
  depends_on           = [azurerm_nat_gateway.gw_aks, azurerm_public_ip.publicip]
}
# Associating NAT Gateway with Subnet 
resource "azurerm_subnet_nat_gateway_association" "sn_cluster_nat_gw" {
  subnet_id      = azurerm_subnet.aks-default.id
  nat_gateway_id = azurerm_nat_gateway.gw_aks.id
  depends_on       = [azurerm_nat_gateway.gw_aks, azurerm_subnet.aks-default]
}

# Associating NAT Gateway with another Subnet 
resource "azurerm_subnet_nat_gateway_association" "sn1_cluster_nat_gw" {
  subnet_id      = azurerm_subnet.aks-default-1.id
  nat_gateway_id = azurerm_nat_gateway.gw_aks.id
  depends_on       = [azurerm_nat_gateway.gw_aks, azurerm_subnet.aks-default-1]
}