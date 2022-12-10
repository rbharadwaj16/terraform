owner = "raghav"
location = "australiaeast"
env = "dev"
location_short = "aue"
####################### Resource Group Module ####################################
rg_name = ["platform"] #add rg name here to create more rg

###################### Network Module ############################################
vnet = {
    hub_vnet = {
        name = "hub"
        address_space = [10.200.0.0/16]
    }
    spoke_vnet = {
        name = "spoke"
        address_space = [10.201.0.0/16]
    }
}


