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
//                AHB SLAVE TOP MODULE
//-----------------------------------------------------------------------------
*/

module ahb_slave_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ahb_slave_pkg::*;

  `include "ahb_slave_tb.sv"
  `include "ahb_slave_test_lib.sv"

  bit HCLK; 
  ahb_slave_if slave_vif(HCLK);

  initial begin
    slave_vif_config::set(null,"*","vif", slave_vif);
    run_test("demo_base_test");
  end

  always
    #10 HCLK = ~HCLK;

endmodule
