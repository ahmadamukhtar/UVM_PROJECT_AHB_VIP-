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
//       AHB MASTER PACKET  CLASS
//--------------------------------------------------------------
*/



class ahb_master_packet extends uvm_sequence_item;
// #(DATA_WIDTH = 32, ADDR_WIDTH = 32, HBURST_WIDTH = 4, HPROT_WIDTH = 3)
  localparam DATA_WIDTH = 32;
  localparam ADDR_WIDTH = 32;
  localparam HBURST_WIDTH = 3;
  localparam HPROT_WIDTH = 4; 
  localparam HTRANS_WIDTH = 2; 
  bit HRESETn;           // reset signal
                                                                    //   input of the maneger...../......drive by master uvc/
  bit HREADY;  
  rand bit [DATA_WIDTH-1:0] HRDATA;
  bit HRESP;
                                                                    //outputs of the maneger ..../.....monitor by the master uvc
  bit [ADDR_WIDTH-1:0]  HADDR;
  bit HWRITE; 
  bit [HBURST_WIDTH:0] HSIZE;
  bit [HBURST_WIDTH-1:0] HBURST;
  bit [HPROT_WIDTH-1:0] HPROT;
  bit [HTRANS_WIDTH-1:0] HTRANS;
  bit HMASTLOCK;
  bit [DATA_WIDTH-1:0] HWDATA;  
                                                        
  function new (string name = "ahb_master_packet");
    super.new(name);
  endfunction : new  
                                                                       //     object_registraction and field automation
  `uvm_object_utils_begin(ahb_master_packet)
      `uvm_field_int(HRESETn, UVM_ALL_ON) 
      `uvm_field_int(HREADY, UVM_ALL_ON)
      `uvm_field_int(HRESP, UVM_ALL_ON)
      `uvm_field_int(HRDATA, UVM_ALL_ON)
      `uvm_field_int(HADDR, UVM_ALL_ON)
      `uvm_field_int(HWRITE, UVM_ALL_ON)
      `uvm_field_int(HSIZE, UVM_ALL_ON)
      `uvm_field_int(HBURST, UVM_ALL_ON)
      `uvm_field_int(HPROT, UVM_ALL_ON)
      `uvm_field_int(HTRANS, UVM_ALL_ON)
      `uvm_field_int(HMASTLOCK, UVM_ALL_ON)
      `uvm_field_int(HWDATA, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
