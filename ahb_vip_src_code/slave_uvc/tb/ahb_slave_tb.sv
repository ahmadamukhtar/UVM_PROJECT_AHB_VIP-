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
//              AHB SLAVE TESTBENCH CLASS
//-----------------------------------------------------------------------------
*/


class ahb_slave_tb extends uvm_env;                                                          

	`uvm_component_utils(ahb_slave_tb)                                                      

	ahb_slave_env slave;                                                               

	function new (string name, uvm_component parent=null);                                                  
		super.new(name, parent);                                                                              
	endfunction                                                                                            

	function void build_phase(uvm_phase phase);                                               
		super.build_phase(phase);                                                                
		set_config_int( "*", "recording_detail", 1);                                                                 
		slave = ahb_slave_env::type_id::create("ahb_slave_env", this);                                                                              
	endfunction                                                     

endclass                                                                                                    

