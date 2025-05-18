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

//----------------------------------------------------------------------
//       AHB MASTER TESTBENCH CLASS
//----------------------------------------------------------------------
*/



class ahb_master_tb extends uvm_env;
  `uvm_component_utils(ahb_master_tb)
 //====creating handle for the environmet class=====
  ahb_master_env ahb_master_1;

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_config_int( "*", "recording_detail", 1);  // turn on recording details
    ahb_master_1 = ahb_master_env::type_id::create("ahb_master_1", this);
  endfunction

endclass

