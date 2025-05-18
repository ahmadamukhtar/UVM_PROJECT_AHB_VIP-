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
//              AHB SLAVE ENVIRONMENT CLASS
//-----------------------------------------------------------------------------
*/

class ahb_slave_env extends uvm_env;                                                                                                 

	`uvm_component_utils(ahb_slave_env)                                                                          

	ahb_slave_agent agent;                                                                                    

	function new(string name, uvm_component parent);                                                       
		super.new(name, parent);                                                      
	endfunction                                                                                       

	function void build_phase(uvm_phase phase);                                                             
		super.build_phase(phase);                                                                             
		agent = ahb_slave_agent::type_id::create("agent", this);                                                                                             
	endfunction                                                                                           
    
endclass : ahb_slave_env                                                                                   
