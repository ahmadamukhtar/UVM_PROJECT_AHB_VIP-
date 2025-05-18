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
//                             AHB TOP  MODULE
//-----------------------------------------------------------------------------
*/


module ahb_top;
  //=========import packages========
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ahb_master_pkg::*;
    import ahb_slave_pkg::*;
     //=========include design files========
    `include "../sv/ahb_scoreboard.sv"
    `include "ahb_tb.sv"
    `include "ahb_test_lib.sv"
    
    
    

   //============Pass on the interfaces from HW_TOP===========
    initial begin
        slave_vif_config::set(null,"uvm_test_top.tb.slave.agent.*","vif", hw_top.slave_vif);
        master_vif_config::set(null,"uvm_test_top.tb.master.agent.*","vif", hw_top.master_vif);
        run_test("base_test");
    end

endmodule
