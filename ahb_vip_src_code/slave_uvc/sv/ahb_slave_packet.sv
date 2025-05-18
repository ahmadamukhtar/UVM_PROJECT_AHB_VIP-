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
//       AHB SLAVE PACKET  CLASS
//--------------------------------------------------------------
*/
class ahb_slave_packet extends uvm_sequence_item;                                                                               

// Parameter Constants                                                                                   
	localparam ADDR_WIDTH = 32;                                                                
	localparam HBURST_WIDTH = 3;                                                                                       
	localparam HPROT_WIDTH = 4;                                                                             
	localparam DATA_WIDTH = 32;                                                                                               

// Global Signals                                               
	rand bit HRESETn;     // 1-bit active low reset signal                                                                                     

// Select Signals                                                                      	
	rand bit HSELx;     // 1-bit select signal. From Decoder to Slave. There are multiple slave and this signal indicates that the current transfer is intended for the selected Subordinate                          

// Address and Control Signals                                                                                             	
	rand bit [ADDR_WIDTH-1:0] HADDR;     // Address of transfer. From Master to Decoder and Slave                                                                                                    
	rand bit HWRITE;     // 1-bit signal which Indicate flow of transfer. From Master to Slave. Indicate WRITE transfer when HIGH and READ transfer when LOW                                                         
	rand bit [2:0] HSIZE;     // 3-bit signal from Master to Slave. Indicate size of transfer                                                                             
	rand bit [HBURST_WIDTH-1:0] HBURST;     // Indicates how many transfers are in the burst and how the address increments. HBURST_WIDTH must be 0 or 3 . From Master to Slave                    
	rand bit [HPROT_WIDTH-1:0] HPROT;     // Protection control Signal which give information about access type. From Master to Slave                                                      
	rand bit [1:0] HTRANS;     // 2-bit signal from Master to Slave. Indicates the transfer type ( IDLE, BUSY, NONSEQUENTIAL, SEQUENTIAL)                                                                                 
	rand bit HMASTLOCK;     // 1-bit signal from Master to Slave. Indicate that current transfer is part of locked sequence                                                                                
	bit HREADY;     // 1-bit signal from Multiplexor to Master and Slave. Indicate previous transfer is completed when HIGH                                                                          
	
// Write Data Signal                                                                            	
	rand bit [DATA_WIDTH-1:0] HWDATA;     // Write Data value. From Master to Slave during WRITE operation                                                                                           
	
// Transfer Response Signals                                                    
	bit HREADYOUT;     // 1-bit signal from Slave to Multiplexor. When HIGH indicate that transfer is completed on bus                                                                                
	bit HRESP;     // 1-bit signal from Slave to Multiplexor. Give Master additional info on status of transfer. When LOW transfer status is OKAY and when HIGH transfer status is ERROR                   
	
// Read Data Signal                                                                                         
	bit [DATA_WIDTH-1:0] HRDATA;     // Read Data value. From Slave to Multiplexor during Read operation                                                                          
	
// utility                                                                                     
	`uvm_object_utils_begin(ahb_slave_packet)                                                                                                 
		`uvm_field_int(HRESETn, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HSELx, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HADDR, UVM_ALL_ON+UVM_DEC)                                                                                                                 
		`uvm_field_int(HWRITE, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HSIZE, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HBURST, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HPROT, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HTRANS, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HMASTLOCK, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HREADY, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HWDATA, UVM_ALL_ON+UVM_DEC)                                                                                                                 
		`uvm_field_int(HREADYOUT, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HRESP, UVM_ALL_ON)                                                                                                                 
		`uvm_field_int(HRDATA, UVM_ALL_ON)                                                                                                                 
	`uvm_object_utils_end                                                                                               
    
	function new (string name = "ahb_slave_packet");                                                                                       
		super.new(name);                                                                           
	endfunction : new                                                                              

endclass : ahb_slave_packet                                                                                            
