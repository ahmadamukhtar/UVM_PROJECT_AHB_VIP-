# UVM_PROJECT_AHB_VIP
AHB_VIP



AHB_VIP UVM_PROJECT_AHB_VIP The project aims to develop the VIP for the AHB protocol. It consists 
of two UVCs and one top-level environment: the master UVC to verify master and the slave UVC to verify slave, 
individually. The master UVC contains the sequences to drive the master interface and assertions to 
verify the behavior of the master DUT interface, while the slave UVC contains the sequences to drive the slave (subordinate) interface 
and assertions to verify the functional behavior of the slave AHB DUT interface. The top-level environment instantiates the master 
and slave UVCs to verify the bus (interconnect) functionality.
