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
//            AHB MASTER Package
//--------------------------------------------------------------
*/
package ahb_master_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef uvm_config_db#(virtual ahb_master_if) master_vif_config;

`include "ahb_master_packet.sv"
`include "ahb_master_monitor.sv"
`include "ahb_master_sequencer.sv"
`include "ahb_master_seqs.sv"
`include "ahb_master_driver.sv"
`include "ahb_master_agent.sv"
`include "ahb_master_env.sv"

endpackage : ahb_master_pkg
