# UVM_PROJECT_AHB_VIP
AHB_VIP


The project aims to develop the VIP for the AHB protocol. It consists of two UVCs and one top-level environment: the master UVC to verify the master interface and the slave UVC to verify the slave interface, individually. For this purpose, we have applied assertions according to the specified behavior of the respective DUT. Each UVC contains sequences to drive the respective DUT and monitor its output to verify protocol compliance.

The VIP supports multi-manager functionality, which allows the user to instantiate the UVCs according to the number of interfaces available in the design. Additionally, coverage for the UVCs is collected separately. The scoreboard is used to verify both the VIP and data verification.


