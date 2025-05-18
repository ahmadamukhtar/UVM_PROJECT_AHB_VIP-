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
//       AHB MASTER SEQUENCER CLASS
//--------------------------------------------------------------
*/
class ahb_master_sequencer extends uvm_sequencer #(ahb_master_packet);



  `uvm_component_utils(ahb_master_sequencer)
  
  
  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction
  
  
endclass
