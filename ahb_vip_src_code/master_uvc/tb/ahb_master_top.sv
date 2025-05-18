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
//       AHB MASTER TOP MODULE
//----------------------------------------------------------------------
*/



module ahb_master_top;
//=========import packages========
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ahb_master_pkg::*;
//=========include sv files==========
  `include "ahb_master_tb.sv"
  `include "ahb_master_test_lib.sv"

  bit clk; 
  
  //======instantiating interface======
  ahb_master_if master_vif(clk);

  initial begin
    master_vif_config::set(null,"*","vif", master_vif);
    run_test("base_test");
  end

  always
    #10 clk = ~clk;

endmodule
