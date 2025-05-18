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
//       AHB MASTER AGENT CLASS
//--------------------------------------------------------------
*/
class ahb_master_agent extends uvm_agent;
  
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
    
  `uvm_component_utils(ahb_master_agent)
  //======create handles for driver, monitor and sequencer=======
  ahb_master_driver driver;
  ahb_master_monitor monitor;
  ahb_master_sequencer sequencer;

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = ahb_master_monitor::type_id::create("monitor", this);
   //======create active or passive agent based on the is_active signal=====    
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer::type_id::create("sequencer", this);
      driver = ahb_master_driver::type_id::create("driver", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin
    //=======Connect driver's seq_item_port with sequencer's seq_item_export
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end 
  endfunction
  
  
endclass
