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
//               AHB TOP  TEST LIBRARY CLASS
//-----------------------------------------------------------------------------
*/
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  ahb_tb tb;
  uvm_objection obj;

  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);


    tb = ahb_tb::type_id::create("tb", this);
  endfunction
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    obj = phase.get_objection();
    obj.set_drain_time(this, 20ns);
  endtask
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
endclass

//-----------------------------------------------------------------------------
// =======Execute the single read after write test=====
//-----------------------------------------------------------------------------


class Test_case0 extends base_test;
  `uvm_component_utils(Test_case0)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        single_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        single_burst_write_read_at_variable_hsize::get_type());


  endfunction
endclass





//------------------------------------------------------------------------------
// =======Execute the INCR4 read after write test=====
//------------------------------------------------------------------------------


class Test_case1 extends base_test;
  `uvm_component_utils(Test_case1)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR4_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        incr_4_write_read::get_type());


  endfunction
endclass

//------------------------------------------------------------------------------
// =======Execute the INCR8 read after write test=====
//------------------------------------------------------------------------------


class Test_case2 extends base_test;
  `uvm_component_utils(Test_case2)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR8_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        incr_8_write_read::get_type());


  endfunction
endclass


//------------------------------------------------------------------------------
// =======Execute the INCR16 read after write test=====
//------------------------------------------------------------------------------


class Test_case3 extends base_test;
  `uvm_component_utils(Test_case3)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR16_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        incr_16_write_read::get_type());


  endfunction
endclass


//--------------------------------------------------------------------------------
// =======Execute the WRAP4 read after write test=====
//--------------------------------------------------------------------------------

class Test_case4 extends base_test;
  `uvm_component_utils(Test_case4)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR4_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        wrap_4_write_read::get_type());


  endfunction
endclass



//--------------------------------------------------------------------------------
// =======Execute the WRAP8 read after write test=====
//--------------------------------------------------------------------------------

class Test_case5 extends base_test;
  `uvm_component_utils(Test_case5)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR8_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        wrap_8_write_read::get_type());


  endfunction
endclass




//--------------------------------------------------------------------------------
// =======Execute the WRAP16 read after write test=====
//--------------------------------------------------------------------------------

class Test_case6 extends base_test;
  `uvm_component_utils(Test_case6)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        INCR16_read_burst::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        wrap_16_write_read::get_type());


  endfunction
endclass




//------------------------------------------------------------------------------------------------
// =======Execute the Comprehensive read after write test=======
//------------------------------------------------------------------------------------------------

class Test_case7 extends base_test;
  `uvm_component_utils(Test_case7)
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "*master*sequencer.run_phase",
                        "default_sequence",
                        manager_all_seq::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        slave_all_seq::get_type());


  endfunction
endclass



