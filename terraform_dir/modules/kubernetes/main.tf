resource "azurerm_kubernetes_cluster" "aks" {
    name = "${var.owner}_${var.env}_${var.purpose}_${var.location_short}"
    location = var.location
    resource_group_name = var.aks_rg_name
    dns_prefix = "${var.owner}_${var.env}_${var.purpose}_${var.location_short}"

    default_node_pool  {
        name = "default"
        vm_size = "Standard_D2s_v3"
        enable_auto_scaling = true
        enable_node_public_ip = false
        os_disk_type = "Managed"
        os_sku = "Ubuntu"
        pod_subnet_id = var.default_pool_subnet_id  
        vnet_subnet_id = var.node_pool_subnet_id
        max_count = 3
        min_count = 1
        node_count = 1
        }

    identity  {
        type = "SystemAssigned"
        }

    network_profile  {
            network_plugin = "azure"
            network_policy = "azure"
            dns_service_ip = var.dns_service_ip
            docker_bridge_cidr = var.docker_bridge_cidr
            outbound_type = "loadBalancer"
            load_balancer_sku = "standard"

        }
  
}