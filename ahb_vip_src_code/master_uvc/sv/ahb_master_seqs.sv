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
//       AHB MASTER SEQUENCES  CLASS
//--------------------------------------------------------------
*/




//----------------------------
//       Base Sequence
//----------------------------
class ahb_master_base_seq extends uvm_sequence #(ahb_master_packet);
  `uvm_object_utils(ahb_master_base_seq)

  function new(string name="ahb_master_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
      phase = starting_phase;
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask


  task post_body();
    uvm_phase phase;
      phase = starting_phase;
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask

endclass : ahb_master_base_seq


class simple_seq extends ahb_master_base_seq;

  `uvm_object_utils(simple_seq)

  function new(string name="simple_seq");
    super.new(name);
  endfunction  

  task body();
    `uvm_info(get_type_name(), "Starting simple_seq sequence", UVM_MEDIUM)
    repeat(5)
      `uvm_do(req)
  endtask
endclass




//------------------------------------------
//      Sequence for single read
//-----------------------------------------


class single_read_burst extends ahb_master_base_seq;

  `uvm_object_utils(single_read_burst)

  function new(string name="single_read_burst");
    super.new(name);
  endfunction  
  
  task body();
              `uvm_info(get_type_name(), "Starting single_read_burst sequence", UVM_MEDIUM)  
              `uvm_do_with(req,{ HRDATA==16;})
        //      `uvm_do_with(req,{ HRDATA==16;})
       //       `uvm_do_with(req,{ HRDATA==16;})
  endtask



endclass



//---------------------------------------------------------------------------
//      Sequence for reading an INCR4 or WRAP4 burst
//---------------------------------------------------------------------------

class INCR4_read_burst extends ahb_master_base_seq;

  `uvm_object_utils(INCR4_read_burst)

  function new(string name="INCR4_read_burst");
    super.new(name);
  endfunction  
  
  task body();
              `uvm_info(get_type_name(), "Starting INCR4_read_burst sequence", UVM_MEDIUM)  
              `uvm_do_with(req,{ HRDATA==16;})
              `uvm_do_with(req,{ HRDATA==17; })
              `uvm_do_with(req,{ HRDATA==18;})
              `uvm_do_with(req,{ HRDATA==19;})
  endtask



endclass

//---------------------------------------------------------------------------
//      Sequence for reading an INCR8 or WRAP8 burst
//---------------------------------------------------------------------------


class INCR8_read_burst extends ahb_master_base_seq;

  `uvm_object_utils(INCR8_read_burst)

  function new(string name="INCR8_read_burst");
    super.new(name);
  endfunction  
  
  task body();
              `uvm_info(get_type_name(), "Starting INCR8_read_burst sequence", UVM_MEDIUM)  
              `uvm_do_with(req,{ HRDATA==16;})
              `uvm_do_with(req,{ HRDATA==17; })
              `uvm_do_with(req,{ HRDATA==18;})
              `uvm_do_with(req,{ HRDATA==19;})
              `uvm_do_with(req,{ HRDATA==20;})
              `uvm_do_with(req,{ HRDATA==21; })
              `uvm_do_with(req,{ HRDATA==22;})
              `uvm_do_with(req,{ HRDATA==23;})
         //     `uvm_do_with(req,{ HRDATA==5; })
  endtask



endclass


//-------------------------------------------------------------------------------
//      Sequence for reading an INCR16 or WRAP16 burst
//-------------------------------------------------------------------------------


class INCR16_read_burst extends ahb_master_base_seq;

  `uvm_object_utils(INCR16_read_burst)

  function new(string name="INCR16_read_burst");
    super.new(name);
  endfunction  
  
  task body();
              `uvm_info(get_type_name(), "Starting INCR16_read_burst sequence", UVM_MEDIUM)  
              `uvm_do_with(req,{ HRDATA==16;})
              `uvm_do_with(req,{ HRDATA==17; })
              `uvm_do_with(req,{ HRDATA==18;})
              `uvm_do_with(req,{ HRDATA==19;})
              `uvm_do_with(req,{ HRDATA==20;})
              `uvm_do_with(req,{ HRDATA==21; })
              `uvm_do_with(req,{ HRDATA==22;})
              `uvm_do_with(req,{ HRDATA==23;})
              `uvm_do_with(req,{ HRDATA==24;})
              `uvm_do_with(req,{ HRDATA==25; })
              `uvm_do_with(req,{ HRDATA==26;})
              `uvm_do_with(req,{ HRDATA==27;})
              `uvm_do_with(req,{ HRDATA==28;})
              `uvm_do_with(req,{ HRDATA==29; })
              `uvm_do_with(req,{ HRDATA==30;})
              `uvm_do_with(req,{ HRDATA==31;})
         //     `uvm_do_with(req,{ HRDATA==5; })
  endtask




//-----------------------------------------------------------------------------
//     Combining all sequences for a comprehensive test
//-----------------------------------------------------------------------------


endclass
class manager_all_seq extends ahb_master_base_seq;

  `uvm_object_utils(manager_all_seq)
    single_read_burst			seq_1;
    INCR4_read_burst         seq_2;
    INCR8_read_burst         seq_3;
    INCR16_read_burst       seq_4;
  function new(string name="manager_all_seq");
    super.new(name);
  endfunction  
  
  task body();
              `uvm_info(get_type_name(), "Starting manager_all_seq  sequence", UVM_MEDIUM)  
              `uvm_do(seq_1);
               `uvm_do(seq_2);
               `uvm_do(seq_2);
               `uvm_do(seq_3);
               `uvm_do(seq_4);
               `uvm_do(seq_4);
               `uvm_do(seq_2);
               `uvm_do(seq_3);
               `uvm_do(seq_4);
               `uvm_do(seq_2);
  endtask



endclass





