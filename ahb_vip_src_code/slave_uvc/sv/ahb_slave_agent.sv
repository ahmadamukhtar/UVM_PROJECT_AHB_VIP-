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
//                    AHB SLAVE agent CLASS
//-----------------------------------------------------------------------------
*/
class ahb_slave_agent extends uvm_agent;                                                                                                              

	protected uvm_active_passive_enum is_active = UVM_ACTIVE;                                                                                     
	`uvm_component_utils(ahb_slave_agent)                                                                                                 
	ahb_slave_driver driver;                                                                                            
	ahb_slave_monitor monitor;                                                                                           
	ahb_slave_sequencer sequencer;                                                                                                             

	function new(string name, uvm_component parent);                                                                            
		super.new(name, parent);                                                                                           
	endfunction                                                                                 

	function void build_phase(uvm_phase phase);                                                                             
		super.build_phase(phase);                                                                                            
		monitor = ahb_slave_monitor::type_id::create("monitor", this);                                                                                               
		if(is_active == UVM_ACTIVE)                                                                                                               
		begin                                                                                               
			sequencer = ahb_slave_sequencer::type_id::create("sequencer", this);                                                             
			driver = ahb_slave_driver::type_id::create("driver", this);                                                                                    
		end                                                                                                 
	endfunction                                                                               

	function void connect_phase(uvm_phase phase);                                                                             
		super.connect_phase(phase);                                                                                      
		if(is_active == UVM_ACTIVE)                                                                                      
		begin                                                                                                                           
			driver.seq_item_port.connect(sequencer.seq_item_export);                                                                                     
		end                                                                                                                
	endfunction                                                                                                                      
    
endclass : ahb_slave_agent                                                                                                                               
