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
//       AHB SLAVE SEQUENCES  CLASS
//--------------------------------------------------------------
*/
class ahb_slave_base_seq extends uvm_sequence #(ahb_slave_packet);                                                                                                       

	`uvm_object_utils(ahb_slave_base_seq)                                                                 

	function new(string name="ahb_slave_base_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        

	task pre_body();
		uvm_phase phase;                                                        
		phase = starting_phase;                                                                                 
		if (phase != null)                                                            
		begin                                                   
		  phase.raise_objection(this, get_type_name());                                                                  
		  `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)                                                                              
		end                                                                                   
	endtask                                                                                                                

	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing ahb_slave_base_seq", UVM_HIGH)                                                       
		repeat(5)                                                                               
		begin                                                           
			`uvm_do(req)                                                                                                
		end                                                                                
	endtask                                                                                                                                   
	task post_body();
		uvm_phase phase;                                                                                   
		phase = starting_phase;                                                                               
		if (phase != null)                                                                                                                       
		begin                                                                                          
			phase.drop_objection(this, get_type_name());                                                                                                 
			`uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)                                                                                                     
		end                                                                                                                           
	endtask

endclass : ahb_slave_base_seq                                                                                          

//------------------------------------------
//            Reset Sequence 
//-----------------------------------------

class single_reset extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(single_reset)                                                                                           
	function new(string name="single_reset");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing single_reset", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1;HRESETn==0;HTRANS==2'b00; })                                                                                                
	  	`uvm_do_with(req, { HSELx==1;HRESETn==1;HTRANS==2'b00; })                                                                                                
	endtask                                                                                                                                   
endclass : single_reset     

//--------------------------------------------
//    Write Read during idle state
//-------------------------------------------
class idle_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(idle_seq)                                                                                                                                                         
	function new(string name="idle_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                                           
		`uvm_info(get_type_name(), "Executing idle_seq", UVM_HIGH)                                                                              
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; })   
        `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; }) 
        `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==0;HRESETn==1;HWDATA==17;HMASTLOCK==0; })   
      `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==4;HRESETn==1;HWDATA==18;HMASTLOCK==0; })     
	endtask                                                                                                                                   
endclass : idle_seq                                       


//------------------------------------------------------------------------------------------------
//  During waited transfer of single burst change from idle to non-seq
//------------------------------------------------------------------------------------------------
class Waited_transfer_IDLE_to_NONSEQ extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(Waited_transfer_IDLE_to_NONSEQ)                                                                                                                                                         
	function new(string name="Waited_transfer_IDLE_to_NONSEQ");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                                           
		`uvm_info(get_type_name(), "Executing Waited_transfer_IDLE_to_NONSEQ", UVM_HIGH)                                                                              
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b10;    HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; })   
        `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; }) 
        `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10; HBURST==0; HPROT==4'b0011;HTRANS==2'b00;    HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; })   
    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10;HBURST==2'b0;HPROT==4'b0011;HTRANS==2'b10;    HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; })
     `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10;HBURST==2'b0;HPROT==4'b0011;HTRANS==2'b11;    HADDR==16;HRESETn==1;HWDATA==18;HMASTLOCK==0; })
   `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==2'b10;HBURST==2'b0;HPROT==4'b0011;HTRANS==2'b00;    HADDR==20;HRESETn==1;HWDATA==18;HMASTLOCK==0; })  
	endtask                                                                                                                                   
endclass :  Waited_transfer_IDLE_to_NONSEQ 


 

//-----------------------------------------------
//    Single Write Burst transaction
//-----------------------------------------------
class single_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(single_burst_simple_write_seq)                                                                
	rand	 bit [2:0] hsize;                                                                                                  
	rand bit [31:0] haddr;                                                                                              
	function new(string name="single_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                                           
		`uvm_info(get_type_name(), "Executing single_burst_simple_write_seq", UVM_HIGH)                                                                              
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==hsize; HBURST==0; HPROT==4'b0011; HTRANS==2'b10;    HADDR==haddr;HRESETn==1;HWDATA==15;HMASTLOCK==0; })  
	  	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==hsize; HBURST==0; HPROT==4'b0011; HTRANS==2'b00;    HADDR==haddr;HRESETn==1;HWDATA==16;HMASTLOCK==0; }) 
	endtask                                                                                                                                   
endclass : single_burst_simple_write_seq                                                                              

//----------------------------------------------
//    Single Read Burst transaction
//----------------------------------------------                                                     
class single_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(single_burst_simple_read_seq)                                                                                           
	rand	 bit [2:0] hsize;                                                                               
	rand bit [31:0] haddr;                                                                                              
	function new(string name="single_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing single_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==hsize; HBURST==0; HPROT==4'b0011; HTRANS==2'b10;    HADDR==haddr;HRESETn==1;HMASTLOCK==0; })                         
	  	`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==hsize; HBURST==0; HPROT==4'b0011; HTRANS==2'b00;     HADDR==haddr;HRESETn==1;HMASTLOCK==0; })                        
	endtask        
endclass : single_burst_simple_read_seq                                                                                                                         
  

//-----------------------------------------------
//    INCR4 Burst Write Transaction
//-----------------------------------------------                                                   
class incr_4_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_4_burst_simple_write_seq)                                                                                           
	function new(string name="incr_4_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_4_burst_simple_write_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b10;HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b01;HADDR==12;HRESETn==1;HWDATA==17;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011;HTRANS==2'b11;HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011;HTRANS==2'b00;HADDR==32;HRESETn==1;HWDATA==19;HMASTLOCK==0; }) 
	endtask        
endclass : incr_4_burst_simple_write_seq                                                                                                                         


//-----------------------------------------------
//    INCR4 Burst Read Transaction
//-----------------------------------------------                                                       
class incr_4_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_4_burst_simple_read_seq)                                                                                           
	function new(string name="incr_4_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_4_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b10;HADDR==0;HRESETn==1;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==4;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==8;HRESETn==1;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b01;HADDR==12;HRESETn==1;HMASTLOCK==0; })      
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==12;HRESETn==1;HMASTLOCK==0; })    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b00;HADDR==32;HRESETn==1;HMASTLOCK==0; })  
	endtask        
endclass : incr_4_burst_simple_read_seq                                        


                                                                                 
//----------------------------------------------------------------------------------------------------------
//    INCR4 Burst Write Transaction with additional Busy states from master
//----------------------------------------------------------------------------------------------------------                                                  
class incr_4_burst_simple_write_wait_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_4_burst_simple_write_wait_seq)                                                                                           
	function new(string name="incr_4_burst_simple_write_wait_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_4_burst_simple_write_wait_seq", UVM_HIGH)   
        `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b10;HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; })  
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b01;HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; }) 
	     `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b01;HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; }) //   
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==0; HPROT==4'b0011; HTRANS==2'b00;HADDR==32;HRESETn==1;HWDATA==19;HMASTLOCK==0; })  
	endtask        
endclass : incr_4_burst_simple_write_wait_seq                                                                                                                         


//----------------------------------------------------------------------------------------------------------
//    INCR4 Burst Read Transaction with additional Busy states from master
//----------------------------------------------------------------------------------------------------------                                                           
class incr_4_burst_simple_read_wait_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_4_burst_simple_read_wait_seq)                                                                                           
	function new(string name="incr_4_burst_simple_read_wait_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_4_burst_simple_read_wait_seq", UVM_HIGH)          
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==0; }) 
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b01;    HADDR==4;HRESETn==1;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })       
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==3; HPROT==4'b0011; HTRANS==2'b00;    HADDR==32;HRESETn==1;HMASTLOCK==0; })   
	endtask        
endclass : incr_4_burst_simple_read_wait_seq                                                                                                                         


//-----------------------------------------------
//    INCR8 Burst Write Transaction
//-----------------------------------------------                                                      
class incr_8_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_8_burst_simple_write_seq)                                                                                           
	function new(string name="incr_8_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_8_burst_simple_write_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b01;    HADDR==12;HRESETn==1;HWDATA==17;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HWDATA==19;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HWDATA==20;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HWDATA==21;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HWDATA==22;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==0; HPROT==4'b0011; HTRANS==2'b00;    HADDR==32;HRESETn==1;HWDATA==23;HMASTLOCK==0; })
	endtask        
endclass : incr_8_burst_simple_write_seq                                                                                                                         


//-----------------------------------------------
//    INCR8 Burst Read Transaction
//-----------------------------------------------                                                      
class incr_8_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_8_burst_simple_read_seq)                                                                                           
	function new(string name="incr_8_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_8_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })     
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b01;    HADDR==12;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })  //    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HMASTLOCK==0; })        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==5; HPROT==4'b0011; HTRANS==2'b00;    HADDR==32;HRESETn==1;HMASTLOCK==0; })                        
	endtask        
endclass : incr_8_burst_simple_read_seq                                                 


//-------------------------------------------------
//    INCR16 Burst Write Transaction
//-------------------------------------------------                                                       
class incr_16_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_16_burst_simple_write_seq)                                                                                           
	function new(string name="incr_16_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
 `uvm_info(get_type_name(), "Executing incr_16_burst_simple_write_seq", UVM_HIGH)                                                       
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; })        
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; })        
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; })     
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; })    // 
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HWDATA==19;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HWDATA==20;HMASTLOCK==0; })     
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HWDATA==21;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HWDATA==22;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1;HWDATA==23;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1;HWDATA==24;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==40;HRESETn==1;HWDATA==25;HMASTLOCK==0; })      
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1;HWDATA==26;HMASTLOCK==0; })    
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1;HWDATA==27;HMASTLOCK==0; })    
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1;HWDATA==28;HMASTLOCK==0; }) 	
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1;HWDATA==29;HMASTLOCK==0; })    
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HWDATA==30;HMASTLOCK==0; })     
 `uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1;HWDATA==31;HMASTLOCK==0; })       
	endtask       
endclass : incr_16_burst_simple_write_seq                                                                                                                         


//-------------------------------------------------
//    INCR16 Burst Read Transaction
//-------------------------------------------------                                                      
class incr_16_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_16_burst_simple_read_seq)                                                                                           
	function new(string name="incr_16_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_16_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==0; })                           
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })                    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })                   
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HMASTLOCK==0; })           
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HMASTLOCK==0; })                 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HMASTLOCK==0; })           
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HMASTLOCK==0; })           
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1;HMASTLOCK==0; })       
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1;HMASTLOCK==0; })             
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==40;HRESETn==1;HMASTLOCK==0; })               
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1;HMASTLOCK==0; })                      
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1;HMASTLOCK==0; })                    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1;HMASTLOCK==0; })         
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HMASTLOCK==0; })                    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1;HMASTLOCK==0; })                
	endtask        
endclass : incr_16_burst_simple_read_seq                              



                                    
//-------------------------------------------------------------------------------------------------
//    INCR16 Burst Write & Locked Transaction along with Busy states
//-------------------------------------------------------------------------------------------------                                                 
class incr_16_burst_simple_write_lock_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_16_burst_simple_write_lock_seq)                                                                                           
	function new(string name="incr_16_burst_simple_write_lock_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
         `uvm_info(get_type_name(), "Executing incr_16_burst_simple_write_lock_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HWDATA==15;   HMASTLOCK==1;})     				     
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==16; HMASTLOCK==1;})      
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==17;  HMASTLOCK==1;})   
  		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b01;    HADDR==12;HRESETn==1;HWDATA==18;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b01;    HADDR==12;HRESETn==1;HWDATA==18;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==18;  HMASTLOCK==1;})  
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HWDATA==19;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HWDATA==20;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HWDATA==21; HMASTLOCK==1; }) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HWDATA==22;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1;HWDATA==23;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1;HWDATA==24;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==40;HRESETn==1;HWDATA==25;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1;HWDATA==26;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1;HWDATA==27; HMASTLOCK==1; }) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1;HWDATA==28;  HMASTLOCK==1;}) 	
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1;HWDATA==29;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HWDATA==30;  HMASTLOCK==1;}) 
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1;HWDATA==31; HMASTLOCK==0; })
	endtask        
endclass : incr_16_burst_simple_write_lock_seq                                                                                                                         


//------------------------------------------------------------------------------------------------
//    INCR16 Burst Read & Locked Transaction along with Busy states
//------------------------------------------------------------------------------------------------                                                      
class incr_16_burst_simple_read_lock_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_16_burst_simple_read_lock_seq)                                                                                           
	function new(string name="incr_16_burst_simple_read_lock_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_16_burst_simple_read_lock_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==1; })      
		 `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==1;  })   
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1; HMASTLOCK==1; })                                  
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1; HMASTLOCK==1; })    
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1; HMASTLOCK==1; })    
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1; HMASTLOCK==1; })    
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1; HMASTLOCK==1; }) 
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HMASTLOCK==1;  })
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b01;    HADDR==32;HRESETn==1;HMASTLOCK==1;  })  
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1; HMASTLOCK==1; })    
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1; HMASTLOCK==1; })    
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==40;HRESETn==1; HMASTLOCK==1; })    
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1; HMASTLOCK==1; })             
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1; HMASTLOCK==1; })    
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1; HMASTLOCK==1; })    
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1; HMASTLOCK==1; })        
 		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HMASTLOCK==1;  }) 
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==7; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1; HMASTLOCK==0; })                               
	endtask        
endclass : incr_16_burst_simple_read_lock_seq

//-----------------------------------------------------------------------
//    Undefined length INCR Write Burst with 4 beats
//-----------------------------------------------------------------------                                                       
class incr_infinite_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_infinite_burst_simple_write_seq)                                                                                           
	function new(string name="incr_infinite_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
	`uvm_info(get_type_name(), "Executing incr_infinite_burst_simple_write_seq", UVM_HIGH)                                                       
	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HWDATA==15;HMASTLOCK==0; })        
	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==16;HMASTLOCK==0; })
	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b01;    HADDR==8;HRESETn==1;HWDATA==16;HMASTLOCK==0; })        
	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==17;HMASTLOCK==0; })       
 	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==18;HMASTLOCK==0; })      
 	`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b00;    HADDR==12;HRESETn==1;HWDATA==19;HMASTLOCK==0; })       
	endtask        
endclass : incr_infinite_burst_simple_write_seq                                                                                                                         


//-----------------------------------------------------------------------
//    Undefined length INCR Read Burst with 4 beats
//-----------------------------------------------------------------------                                                       
class incr_infinite_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(incr_infinite_burst_simple_read_seq)                                                                                           
	function new(string name="incr_infinite_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_infinite_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==0; })                         
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })                                
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b01;    HADDR==12;HRESETn==1;HMASTLOCK==0; })                      
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })                              
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b00;    HADDR==16;HRESETn==1;HMASTLOCK==0; })                         
	endtask        
endclass : incr_infinite_burst_simple_read_seq              


                                                                                                           


//--------------------------------------------------------------------------------------------------------
//    Undefined length INCR Read Burst with beats exceeding 1KB memory
//--------------------------------------------------------------------------------------------------------                                                      
class incr_infinite_burst_1kb_simple_read_seq extends ahb_slave_base_seq;     
int i=0;                                                                                         
	`uvm_object_utils(incr_infinite_burst_1kb_simple_read_seq)                                                                                           
	function new(string name="incr_infinite_burst_1kb_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing incr_infinite_burst_1kb_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b10;    HADDR==0;HRESETn==1;HMASTLOCK==0; })             
		repeat(1100)    
		begin
		i++;                               
        `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b11;    HADDR==i*4;HRESETn==1;HMASTLOCK==0; })                        
	end
	   `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==1; HPROT==4'b0011; HTRANS==2'b00;    HADDR==1101*4;HRESETn==1;HMASTLOCK==0; })     
	endtask        
endclass : incr_infinite_burst_1kb_simple_read_seq                                          


//--------------------------------------------------------------------------
//    WRAP4 Burst Write Transaction with Busy states
//--------------------------------------------------------------------------                                                                                       
class wrap_4_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_4_burst_simple_write_seq)                                                                                           
	function new(string name="wrap_4_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_4_burst_simple_write_seq", UVM_HIGH)                                                       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b10;   HADDR==4;   HRESETn==1;HWDATA==15;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;   HADDR==8;   HRESETn==1;HWDATA==16;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;   HADDR==12; HRESETn==1;HWDATA==17;HMASTLOCK==0; })
   		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b01;   HADDR==0;   HRESETn==1;HWDATA==18;HMASTLOCK==0; })  
  		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b01;   HADDR==0;   HRESETn==1;HWDATA==18;HMASTLOCK==0; }) 
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;   HADDR==0;   HRESETn==1;HWDATA==18;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b00;   HADDR==12; HRESETn==1;HWDATA==19;HMASTLOCK==0; })      
	endtask        
endclass : wrap_4_burst_simple_write_seq                                                                                                                         


//-------------------------------------------------
//    WRAP4 Burst Read Transaction
//-------------------------------------------------                                                       
class wrap_4_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_4_burst_simple_read_seq)                                                                                           
	function new(string name="wrap_4_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_4_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b10;    HADDR==4;HRESETn==1;HMASTLOCK==0; })                       
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })                
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b11;    HADDR==0;HRESETn==1;HMASTLOCK==0; })     
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==2; HPROT==4'b0011; HTRANS==2'b00;    HADDR==12;HRESETn==1;HMASTLOCK==0; })                       
	endtask        
endclass : wrap_4_burst_simple_read_seq                                                                                                   


//--------------------------------------------------------------------------
//    WRAP8 Burst Write Transaction with Busy states
//--------------------------------------------------------------------------                                                        
class wrap_8_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_8_burst_simple_write_seq)                                                                                           
	function new(string name="wrap_8_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_8_burst_simple_write_seq", UVM_HIGH)                                                       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b10;    HADDR==16;HRESETn==1;HWDATA==15;HMASTLOCK==0; })      
  		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HWDATA==16;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HWDATA==17;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b01;    HADDR==28;HRESETn==1;HWDATA==18;HMASTLOCK==0; })       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b01;    HADDR==28;HRESETn==1;HWDATA==18;HMASTLOCK==0; })       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HWDATA==18;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==0;HRESETn==1;HWDATA==19;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==20;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==21;HMASTLOCK==0; })
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==22;HMASTLOCK==0; }) 	  
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b00;    HADDR==20;HRESETn==1;HWDATA==23;HMASTLOCK==0; })       
	endtask        
endclass : wrap_8_burst_simple_write_seq                                                                                                                         


//--------------------------------------------------------------------------
//    WRAP8 Burst Read Transaction with Busy states
//--------------------------------------------------------------------------                                                        
class wrap_8_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_8_burst_simple_read_seq)                                                                                           
	function new(string name="wrap_8_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_8_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b10;    HADDR==16;HRESETn==1;HMASTLOCK==0; })                            
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HMASTLOCK==0; })                            
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HMASTLOCK==0; })                
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b01;    HADDR==28;HRESETn==1;HMASTLOCK==0; })           
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b01;    HADDR==28;HRESETn==1;HMASTLOCK==0; })                
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HMASTLOCK==0; })                
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==0;HRESETn==1;HMASTLOCK==0; })               
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })                 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; })  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==4; HPROT==4'b0011; HTRANS==2'b00;    HADDR==24;HRESETn==1;HMASTLOCK==0; })                         
	endtask        
endclass : wrap_8_burst_simple_read_seq                                                 


//--------------------------------------------------------------------------
//    WRAP16 Burst Write Transaction with Busy states
//--------------------------------------------------------------------------                                                        
class wrap_16_burst_simple_write_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_16_burst_simple_write_seq)                                                                                           
	function new(string name="wrap_16_burst_simple_write_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_16_burst_simple_write_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b10;    HADDR==40;HRESETn==1;HWDATA==15;HMASTLOCK==0; })       
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1;HWDATA==16;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1;HWDATA==17;HMASTLOCK==0; })     
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b01;    HADDR==52;HRESETn==1;HWDATA==18;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b01;    HADDR==52;HRESETn==1;HWDATA==18;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1;HWDATA==18;HMASTLOCK==0; })    
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1;HWDATA==19;HMASTLOCK==0; })
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HWDATA==20;HMASTLOCK==0; })     
		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==0;HRESETn==1;HWDATA==21;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HWDATA==22;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HWDATA==23;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HWDATA==24;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HWDATA==25;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HWDATA==26;HMASTLOCK==0; })       
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HWDATA==27;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HWDATA==28;HMASTLOCK==0; }) 	  
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1;HWDATA==29;HMASTLOCK==0; })     
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1;HWDATA==30;HMASTLOCK==0; })      
 		`uvm_do_with(req, { HSELx==1; HWRITE==1; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1;HWDATA==31;HMASTLOCK==0; })      
	                                                         
	endtask        
endclass : wrap_16_burst_simple_write_seq                                                                                                                         


//--------------------------------------------------------------------------
//    WRAP16 Burst Read Transaction with Busy states
//--------------------------------------------------------------------------                                                       
class wrap_16_burst_simple_read_seq extends ahb_slave_base_seq;                                                                                              
	`uvm_object_utils(wrap_16_burst_simple_read_seq)                                                                                           
	function new(string name="wrap_16_burst_simple_read_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();        	                                                     
		`uvm_info(get_type_name(), "Executing wrap_16_burst_simple_read_seq", UVM_HIGH)                                                       
		`uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b10;    HADDR==40;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==44;HRESETn==1;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==48;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b01;    HADDR==52;HRESETn==1;HMASTLOCK==0; })                  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b01;    HADDR==52;HRESETn==1;HMASTLOCK==0; })                  
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==52;HRESETn==1;HMASTLOCK==0; })
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==56;HRESETn==1;HMASTLOCK==0; })             
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==60;HRESETn==1;HMASTLOCK==0; })                         
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==0;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==4;HRESETn==1;HMASTLOCK==0; })                    
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==8;HRESETn==1;HMASTLOCK==0; })                      
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==12;HRESETn==1;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==16;HRESETn==1;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==20;HRESETn==1;HMASTLOCK==0; })        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==24;HRESETn==1;HMASTLOCK==0; })                       
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==28;HRESETn==1;HMASTLOCK==0; })                       
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==32;HRESETn==1;HMASTLOCK==0; })                        
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b11;    HADDR==36;HRESETn==1;HMASTLOCK==0; }) 
	    `uvm_do_with(req, { HSELx==1; HWRITE==0; HSIZE==3'b10; HBURST==6; HPROT==4'b0011; HTRANS==2'b00;    HADDR==72;HRESETn==1;HMASTLOCK==0; })  
	endtask        
endclass : wrap_16_burst_simple_read_seq                                                

//------------------------------------------
// Executing idle seq after reset 
//------------------------------------------ 
class idl_simple_seq extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(idl_simple_seq)                                                                                           
	single_reset                              reset_seq;                                                                                    
    idle_seq                                         idle;                                                                                                                                                                                                                                   
	function new(string name="idl_simple_seq");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing idl_simple_seq", UVM_HIGH)      
		`uvm_do(reset_seq);     
		`uvm_do(idle);                                                                                                                        
	endtask                                                                                                                
endclass : idl_simple_seq    


//--------------------------------------------------------------------------------------------------------------------------
// Executing Single burst read after write after reset  with different sizes and addresses
//-------------------------------------------------------------------------------------------------------------------------- 
class single_burst_write_read_at_variable_hsize extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(single_burst_write_read_at_variable_hsize)                                                                                           
	single_reset                              reset_seq;                                                                                    
	single_burst_simple_write_seq  write_seq;                                                                           
	single_burst_simple_read_seq   read_seq;                                                                                        
//	int i = 0;                                                                                                                                                      
	function new(string name="single_burst_write_read_at_variable_hsize");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing single_burst_write_read_at_variable_hsize", UVM_HIGH)      
		`uvm_do(reset_seq);   
		//repeat(3)     
		begin                 
		//	`uvm_do_with(write_seq, {  hsize==0; haddr==0; })                                                                                                
		 //	`uvm_do_with(read_seq, { hsize==0; haddr==0; }) 
		 //	`uvm_do_with(write_seq, {  hsize==1; haddr==2; })                                                                                                
		 //	`uvm_do_with(read_seq, { hsize==1; haddr==2; }) 
		  	`uvm_do_with(write_seq, {  hsize==2; haddr==0; })                                                                                                
		 	`uvm_do_with(read_seq, { hsize==2; haddr==0; })                                                                                     
		 //	i++;                                                                              
	 	end                                                                                              
	endtask                                                                                                                
endclass : single_burst_write_read_at_variable_hsize                                               


//------------------------------------------------------------------------
// Executing INCR4 read after write after doing reset
//------------------------------------------------------------------------ 
class incr_4_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_4_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_4_burst_simple_write_seq  write_seq;                                                                           
	incr_4_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="incr_4_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_4_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_4_write_read        


                                      
//-------------------------------------------------------------------------------------------------
// Executing INCR4 read after write with BUSY states after doing reset
//-------------------------------------------------------------------------------------------------  
class incr_4_wait_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_4_wait_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_4_burst_simple_write_wait_seq  write_seq;                                                                           
	incr_4_burst_simple_read_wait_seq   read_seq;                                                                                        
	function new(string name="incr_4_wait_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_4_wait_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_4_wait_write_read      


//------------------------------------------------------------------------
// Executing INCR8 read after write after doing reset
//------------------------------------------------------------------------ 
class incr_8_write_read extends ahb_slave_base_seq;                                                                                                      
	`uvm_object_utils(incr_8_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_8_burst_simple_write_seq  write_seq;                                                                           
	incr_8_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="incr_8_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_8_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_8_write_read                                                         


//--------------------------------------------------------------------------
// Executing INCR16 read after write after doing reset
//--------------------------------------------------------------------------    
class incr_16_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_16_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_16_burst_simple_write_seq  write_seq;                                                                           
	incr_16_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="incr_16_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_16_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_16_write_read  


//-------------------------------------------------------------------------------------
// Executing Locked INCR16 read after write after doing reset
//-------------------------------------------------------------------------------------   
class incr_16_lock_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_16_lock_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_16_burst_simple_write_lock_seq  write_seq;                                                                           
	incr_16_burst_simple_read_lock_seq   read_seq;                                                                                        
	function new(string name="incr_16_lock_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_16_lock_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_16_lock_write_read  

//---------------------------------------------------------------------------------------------------
// Executing WRAP4 read after write with BUSY states after doing reset
//---------------------------------------------------------------------------------------------------   
class wrap_4_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(wrap_4_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	wrap_4_burst_simple_write_seq  write_seq;                                                                           
	wrap_4_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="wrap_4_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing wrap_4_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : wrap_4_write_read                                                                            


//---------------------------------------------------------------------------------------------------
// Executing WRAP8 read after write with BUSY states after doing reset
//---------------------------------------------------------------------------------------------------  
class wrap_8_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(wrap_8_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	wrap_8_burst_simple_write_seq  write_seq;                                                                           
	wrap_8_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="wrap_8_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing wrap_8_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : wrap_8_write_read                                                                                                     


//---------------------------------------------------------------------------------------------------
// Executing WRAP16 read after write with BUSY states after doing reset
//---------------------------------------------------------------------------------------------------   
class wrap_16_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(wrap_16_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	wrap_16_burst_simple_write_seq  write_seq;                                                                           
	wrap_16_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="wrap_16_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing wrap_16_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : wrap_16_write_read                                                                                     


//--------------------------------------------------------------------------------------------------------------------
// Executing undefined length INCR read after write after doing reset (4 beats each)
//--------------------------------------------------------------------------------------------------------------------  
class incr_infinite_write_read extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_infinite_write_read)                                                                                           
	single_reset                              reset_seq;                                                                                    
	incr_infinite_burst_simple_write_seq  write_seq;                                                                           
	incr_infinite_burst_simple_read_seq   read_seq;                                                                                        
	function new(string name="incr_infinite_write_read");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_infinite_write_read", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                 
			`uvm_do(write_seq)                                                                                                
		 	`uvm_do(read_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_infinite_write_read              


                                                  

//---------------------------------------------------------------------------------------------------------------------------------------------
//  Executing undefined length INCR Read Burst with beats exceeding 1KB memory after doing reset
//---------------------------------------------------------------------------------------------------------------------------------------------   
class incr_infinite_1kb extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(incr_infinite_1kb)                                                                                           
	single_reset                              reset_seq;                                                                                    
   incr_infinite_burst_1kb_simple_read_seq     _1kb_seq;                                                                      
	function new(string name="incr_infinite_1kb");                                                                 
		super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing incr_infinite_1kb", UVM_HIGH)      
		`uvm_do(reset_seq);   
		repeat(1)     
		begin                                                                                                                 
		 	`uvm_do(_1kb_seq)                                                                                
	 	end                                                                                              
	endtask                                                                                                                
endclass : incr_infinite_1kb             



//-------------------------------------------------------------------------------------
// Combination of all sequences to run and check as required 
//-------------------------------------------------------------------------------------

class slave_all_seq extends ahb_slave_base_seq;                                                                                                       
	`uvm_object_utils(slave_all_seq)                                                                                           
	 single_reset                              reset_seq;                                                                                    
    single_burst_write_read_at_variable_hsize   seq_1;     
     incr_4_write_read                          					 seq_2;
     incr_4_wait_write_read                                    seq_3;
     incr_8_write_read                                             seq_4;
	 incr_16_write_read 										     seq_5; 	
	 incr_16_lock_write_read                                  seq_6;
 	 wrap_4_write_read											 seq_7;
 	 wrap_8_write_read											 seq_8;
	 wrap_16_write_read                                         seq_9;
	 incr_infinite_write_read                                   seq_10;
   	function new(string name="slave_all_seq");                                                                 
	super.new(name);                                                                             
	endfunction                                                                                                        
	virtual task body();                                                             
		`uvm_info(get_type_name(), "Executing slave_all_seq sequence", UVM_HIGH)      
	    `uvm_do(reset_seq);   
    repeat(1)     
		begin                      
             `uvm_do(seq_1); 
             `uvm_do(seq_2);
             `uvm_do(seq_3);
             `uvm_do(seq_4);
             `uvm_do(seq_5);
             `uvm_do(seq_6);
             `uvm_do(seq_7);
             `uvm_do(seq_8);
             `uvm_do(seq_9);
             `uvm_do(seq_10);                                                                              
	 	end                                                                                              
	endtask                                                                                                                
 endclass : slave_all_seq             





