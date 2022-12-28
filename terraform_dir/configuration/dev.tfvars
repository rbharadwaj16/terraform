owner = "raghav"
location = "australiaeast"
env = "dev"
location_short = "aue"
purpose_tag = "Test"
owner_tag = "raghavendra.bharadwaj@servian.com"
client_tag = "L&D"
####################### Resource Group Module ####################################
rg_name = ["platform"] #add rg name here to create more rg

###################### Network Module ############################################

network_rg = ["platform"]
vnet = {
    hub_vnet = {
        name = "hub"
        address_space = ["10.200.0.0/16"]
    }
    spoke_vnet = {
        name = "spoke"
        address_space = ["10.201.0.0/16"]
    }
}

subnets = {
    fw_subnet = {
        name = "fw_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.200.0.0/24"]
        vnet_name = "raghav_dev_hub_aue"
    }
    gw_subnet = {
        name = "gw_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.200.1.0/24"]
        vnet_name = "raghav_dev_hub_aue"
    }
    bastion_subnet = {
        name = "bastion_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.200.2.0/24"]
        vnet_name = "raghav_dev_hub_aue"
    }
    host_subnet = {
        name = "host_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.201.0.0/22"]
        vnet_name = "raghav_dev_spoke_aue"
    }
    ingress_subnet = {
        name = "ingress_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.201.4.0/24"]
        vnet_name = "raghav_dev_spoke_aue"
    }
    pe_subnet = {
        name = "pe_subnet"
        subnet_rg = "raghav_dev_platform_aue"
        address_space = ["10.201.5.0/24"]
        vnet_name = "raghav_dev_spoke_aue"
    }
}

################################################### Kube Module #############################################################

purpose = "platform"
aks_rg_name = "raghav_dev_platform_aue"
default_pool_subnet_id = "/subscriptions/58f627af-5f2f-4f24-b8b3-67712c182a5c/resourceGroups/raghav_dev_platform_aue/providers/Microsoft.Network/virtualNetworks/raghav_dev_spoke_aue/subnets/host_subnet"
node_pool_subnet_id = "/subscriptions/58f627af-5f2f-4f24-b8b3-67712c182a5c/resourceGroups/raghav_dev_platform_aue/providers/Microsoft.Network/virtualNetworks/raghav_dev_spoke_aue/subnets/host_subnet"
dns_service_ip = "10.1.0.10"
service_cidr = "10.1.0.0/24"
docker_bridge_cidr = "172.17.0.1/16"

