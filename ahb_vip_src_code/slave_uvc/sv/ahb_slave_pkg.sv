/*
--------------------------------------------
  NUST CHIP DESIGN CENTER
--------------------------------------------
Project name : AHB VIP
Start date : 3rd Dec, 2024
End date : 17th Dec, 2024

Group Members: 
Ahmad Mukhtar
Usama Ahmed
Khizer Mehmood

//--------------------------------------------------------------
//              AHB SLAVE  PACKAGE
//--------------------------------------------------------------
*/
package ahb_slave_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

//=======Creating a typedef for the interface============
typedef uvm_config_db#(virtual ahb_slave_if) slave_vif_config;

`include "ahb_slave_packet.sv"
`include "ahb_slave_monitor.sv"
`include "ahb_slave_sequencer.sv"
`include "ahb_slave_seqs.sv"
`include "ahb_slave_driver.sv"
`include "ahb_slave_agent.sv"
`include "ahb_slave_env.sv"
endpackage : ahb_slave_pkg
