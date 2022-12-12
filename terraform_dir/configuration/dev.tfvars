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

network_rg = ["platform", "test"]
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


