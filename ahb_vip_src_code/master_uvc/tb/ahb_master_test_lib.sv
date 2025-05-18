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
//       AHB MASTER TEST LIBRARY CLASS
//----------------------------------------------------------------------
*/




class base_test extends uvm_test;

  `uvm_component_utils(base_test)
  
  ahb_master_tb tb;
  uvm_objection obj;

  function new(string name = "base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
    uvm_config_wrapper::set(this, "tb*sequencer.run_phase",
                        "default_sequence",
                        INCR8_read_burst::get_type());

    tb = ahb_master_tb::type_id::create("tb", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // =========set drain time as 40ns=====
    obj = phase.get_objection();
    obj.set_drain_time(this, 40ns);
  endtask

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();    // ==== print topology on the console====
  endfunction

endclass : base_test
