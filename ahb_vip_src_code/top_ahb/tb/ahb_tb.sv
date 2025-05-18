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

//-----------------------------------------------------------------------------
//                 AHB TOP TESTBENCH CLASS
//-----------------------------------------------------------------------------
*/

class ahb_tb extends uvm_env;
  `uvm_component_utils(ahb_tb)

  ahb_master_env master;
  ahb_slave_env slave;
  ahb_scorboard scoreboard;

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master = ahb_master_env::type_id::create("master", this);
    slave = ahb_slave_env::type_id::create("slave", this);
    scoreboard = ahb_scorboard::type_id::create("scoreboard", this);
  endfunction
  
  
//===========Connect the fifos in scoreboard with the monitors from the 2 UVCs==========
  function void connect_phase(uvm_phase phase);
    master.agent.monitor.master_mon2scoreboard_port.connect(scoreboard.master_in_fifo.analysis_export);
    slave.agent.monitor.slave_mon2scoreboard_port.connect(scoreboard.slave_in_fifo.analysis_export);
  endfunction


endclass

