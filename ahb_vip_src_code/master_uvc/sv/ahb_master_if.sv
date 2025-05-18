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
//          AHB MASTER INTERFACE
//--------------------------------------------------------------
*/
interface ahb_master_if #(DATA_WIDTH = 32, ADDR_WIDTH = 32, HBURST_WIDTH = 4, HPROT_WIDTH = 3,HSIZE_WIDTH=3,HTRANS_WIDTH=2) (input bit clk);
    logic HRESETn;  
    logic HREADY;  
    logic HRESP;
    logic [DATA_WIDTH-1:0] HRDATA;
    logic [ADDR_WIDTH-1:0] HADDR;
    logic HWRITE; 
    logic [HSIZE_WIDTH-1:0] HSIZE;
    logic [HBURST_WIDTH-1:0] HBURST;
    logic [HPROT_WIDTH-1:0] HPROT;
    logic [HTRANS_WIDTH-1:0] HTRANS;
    logic HMASTLOCK;
    logic [DATA_WIDTH-1:0] HWDATA;  
    logic   past_HWRITE;   
    
    
    
    
    
    //======stores past value of HWRITE=========
    always @(negedge clk)
    begin
    	past_HWRITE <= HWRITE;  
    end
    
  int wrap_start_boundary;
  int wrap_end_boundary;
  int wrap_address;
  int prev_wrap_address;
  
  
  
//-----------------------------------------
// Assertions for seq-1 (simple read write)
//-----------------------------------------


property single_burst_read_after_write;
  @(posedge clk)  
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 0) && (HWRITE == 1) ##1 (HREADY == 1) && (HTRANS == 0) && (HBURST == 0) && (HWRITE == 1) ##1 (HREADY == 1) && (HTRANS == 2) && (HBURST == 0) && (HWRITE == 0) |-> ##1 (HREADY == 1) && (HTRANS == 0) && (HBURST == 0) && (HWRITE == 0) 
endproperty  

//-----------------------------------
// Assertions for seq-2 (INCR4 burst)
//-----------------------------------

// check non-seq is followed by a seq or busy for INCR

property INCR4_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 3) // start of INCR sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty

// Address incr on HREADY
property INCR4_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 3) // mid of INCR
  ##1 (HTRANS == 3) |->  ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == $past(HADDR)+4) )   
endproperty

// Address increment on BUSY
property INCR4_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 3) && (HREADY == 1) //mid of INCR
   ##1 (HTRANS == 1)  && (HBURST == 3) // MASTER BUSY
   |-> (HADDR == $past(HADDR)+4) 
endproperty

// Controls signals retained for the whole burst
property INCR4_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 3) // start of INCR sequence
  |->  ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 3) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*3:$] // control signals retention
  //##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty

//-----------------------------------
// Assertions for seq-3 (INCR8 burst)
//-----------------------------------



// check non-seq is followed by a seq or busy for INCR

property INCR8_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 5) // start of INCR sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty



// Address incr on HREADY
property INCR8_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 5)    // mid of INCR
  ##1   (HTRANS == 3) |->   ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == $past(HADDR)+4) )   
endproperty


// Address increment on BUSY
property INCR8_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 5) && (HREADY == 1)  //mid of INCR
   ##1 (HTRANS == 1)  && (HBURST == 5) // MASTER BUSY
   |-> (HADDR == $past(HADDR)+4) 
endproperty


// Controls signals retained for the whole burst
property INCR8_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 5) // start of INCR sequence
  |-> ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 5) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*7:$] // control signals retention
  //|-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence endsassert property (single_burst_read_after_write); 
endproperty

//-----------------------------------
// Assertions for seq-4 (INCR16 burst)
//-----------------------------------


// check non-seq is followed by a seq or busy for INCR

property INCR16_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 7) // start of INCR sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty



// Address incr on HREADY
property INCR16_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 7) // mid of INCR
   ##1   (HTRANS == 3) |->  ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == $past(HADDR)+4) )   
endproperty


// Address increment on BUSY
property INCR16_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 7) && (HREADY == 1) //mid of INCR
   ##1 (HTRANS == 1)  && (HBURST == 7) // MASTER BUSY
   |-> (HADDR == $past(HADDR)+4) 
endproperty


// Controls signals retained for the whole burst
property INCR16_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 7) // start of INCR sequence
  |->  ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 7) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*15:$] // control signals retention
//  |-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty



//-----------------------------------
// Assertions for seq-5 (WRAP4 burst)
//-----------------------------------

// check non-seq is followed by a seq or busy for INCR

property WRAP4_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 2) // start of WRAP sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty

//========calculating the start and stop boundary for wrap around in WRAP bursts==========

  always_comb
  begin
	  if (HBURST == 2)
	  begin
		  if (HSIZE == 0)
		  begin
			wrap_start_boundary = {HADDR[31:2],2'b00};
			wrap_end_boundary = {HADDR[31:2],2'b11};
		  end
		  else if (HSIZE == 1)
		  begin
			wrap_start_boundary = {HADDR[31:3],3'b000};
			wrap_end_boundary = {HADDR[31:3],3'b111};
		  end
		  else if (HSIZE == 2)
		  begin
			wrap_start_boundary = {HADDR[31:4],4'b0000};
			wrap_end_boundary = {HADDR[31:4],4'b1111};
		  end
		  else if (HSIZE == 3)
		  begin
			wrap_start_boundary = {HADDR[31:5],5'b00000};
			wrap_end_boundary = {HADDR[31:5],5'b11111};
		  end
		  else if (HSIZE == 4)
		  begin
			wrap_start_boundary = {HADDR[31:6],6'b000000};
			wrap_end_boundary = {HADDR[31:6],6'b111111};
		  end
		  else if (HSIZE == 5)
		  begin
			wrap_start_boundary = {HADDR[31:7],7'b0000000};
			wrap_end_boundary = {HADDR[31:7],7'b1111111};
		  end
	  end
	end
	
	
	
	
	
// checking wrap around address
property WRAP4_wrap_around_check;
  	                                                                                           
  @(posedge clk)
  (HBURST == 2) // Wrap4 sequence
  |-> (HADDR >= wrap_start_boundary || HADDR < wrap_end_boundary)
endproperty



// Address incr on HREADY
property WRAP4_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 2) //mid of burst
   ##1   (HTRANS == 3) |->  ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == wrap_address ))   
endproperty

    //=======updata the wrap address======
	always_comb
	begin
	//  if (HREADY == 1)
	 // begin
		if (prev_wrap_address + 4 == wrap_end_boundary)
			wrap_address = wrap_start_boundary;
		else 
			wrap_address = HADDR ;
		//end
   end
   
   //========stores the prev_wrap_address value
   always@(negedge clk)
   begin
         prev_wrap_address <= HADDR;
   end

// Address increment on BUSY
property WRAP4_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 2) && (HREADY == 1) //mid of burst
   ##1 (HTRANS == 1)  && (HBURST == 2) // MASTER BUSY
   |-> (HADDR == wrap_address) 
endproperty



// Controls signals retained for the whole burst
property WRAP4_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 2) // start of burst sequence
  |-> ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 2) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*3:$] // control signals retention
 // |-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty





//-----------------------------------
// Assertions for seq-6 (WRAP8 burst)
//-----------------------------------

// check non-seq is followed by a seq or busy for INCR

property WRAP8_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 4) // start of WRAP sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty



// checking wrap around address
property WRAP8_wrap_around_check;
  	   
  @(posedge clk)
  (HBURST == 4) // Wrap8 sequence
  |-> (HADDR >= wrap_start_boundary || HADDR < wrap_end_boundary)
endproperty



// Address incr on HREADY
property WRAP8_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 4) // mid of burst
  ##1   (HTRANS == 3) |->   ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == wrap_address) )   
endproperty


// Address increment on BUSY
property WRAP8_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 4) && (HREADY == 1) //mid of burst
   ##1 (HTRANS == 1)  && (HBURST == 4) // MASTER BUSY
   |-> (HADDR == wrap_address) 
endproperty



// Controls signals retained for the whole burst
property WRAP8_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 4) // start of burst sequence
  |-> ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 4) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*7:$] // control signals retention
 // |-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty




//------------------------------------------------------
// Assertions for seq-7 (WRAP16 burst)
//------------------------------------------------------

// check non-seq is followed by a seq or busy for INCR

property WRAP16_start;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 6) // start of WRAP sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty



// checking wrap around address
property WRAP16_wrap_around_check;
  	   
  @(posedge clk)
  (HBURST == 6) // Wrap16 sequence
  |-> (HADDR >= wrap_start_boundary || HADDR < wrap_end_boundary)
endproperty



// Address incr on HREADY
property WRAP16_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 4) // mid of burst
  ##1   (HTRANS == 3) |->   ( $past (HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == wrap_address) )   
endproperty


// Address increment on BUSY
property WRAP16_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 6) && (HREADY == 1) //mid of burst
   ##1 (HTRANS == 1)  && (HBURST == 6) // MASTER BUSY
   |-> (HADDR == wrap_address) 
endproperty



// Controls signals retained for the whole burst
property WRAP16_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 6) // start of burst sequence
  |-> ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 6) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*15:$] // control signals retention
//  |-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty


//------------------------------------------------------
// Assertions for seq-8 (INCR burst of undefined length)
//------------------------------------------------------


// Start of the INCR burst
property undef_INCR_start;
  @(posedge clk)  
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 1) // start of INCR sequence
  |-> ##1 (HTRANS == 3) || (HTRANS == 1) && (HADDR == $past(HADDR)+4)
endproperty

// Address increment of HREADY 



property undef_INCR_addr_incr_on_HReady;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 1) // mid of INCR
  ##1   (HTRANS == 3) |->   ( $past(HREADY == 0) ? (HADDR == $past(HADDR)): (HADDR == $past(HADDR)+4) )   
endproperty

// Address increment on BUSY
property undef_INCR_addr_incr_on_BUSY;
  @(posedge clk)
  (HTRANS == 3)  && (HBURST == 1)  && (HREADY == 1)//mid of INCR
   ##1 (HTRANS == 1)  && (HBURST == 1) // MASTER BUSY
   |-> (HADDR == $past(HADDR)+4) 
endproperty

// Controls signals retained for the whole burst
property undef_INCR_control_signals_retention;
  @(posedge clk)
  (HREADY == 1) && (HTRANS == 2) && (HBURST == 1) // start of INCR sequence
  |-> ##1 (HTRANS == 3 || HTRANS == 1) && (HBURST == 1) && (HBURST == $past(HBURST)) && (HSIZE == $past(HSIZE)) && (HPROT == $past(HPROT)) && (HWRITE == $past(HWRITE)) [*1:$] // control signals retention
 // |-> ##1 (HTRANS == 2 || HTRANS == 0) && (HBURST != $past(HBURST)) && (HSIZE != $past(HSIZE)) && (HPROT != $past(HPROT)) && (HWRITE != $past(HWRITE))  // retention loss after sequence ends
endproperty

//---------------------------------------
// Assertions for seq-9 (Locked transfer)
//---------------------------------------

property locked_transfer_2;
  @(posedge clk)
  (HMASTLOCK == 1) && (HREADY == 1)  && (HTRANS == 2) // start of a locked transfer
  |-> ##1 (HMASTLOCK == 1) [*1:$]  // length of the locked transfer can be undefined 
  ##1 (HMASTLOCK == 0) && (HREADY == 1)    	  // Termination of locked transfer
endproperty


property locked_transfer_1;
  @(posedge clk)
  (HMASTLOCK == 1) && (HTRANS !=0)  // Mid of locked sequence
  ##1 (HMASTLOCK == 0)  
  |-> (HTRANS == 0)    // verify the locked transfer is terminated with anassert property (single_burst_read_after_write);  ideal transfer
endproperty

//------------------------------------------------------------------------
// Assertions for seq-10 (during waited transfer idle to non-seq transfer)
//------------------------------------------------------------------------

property idle_transfer;
  @(posedge clk)
  (HREADY == 0) && (HTRANS == 0) // idle during a waited transfer
  ##1 (HTRANS == 2) && (HREADY == 0) // wait for the HREADY to be asserted (HTRANS should stay same till then)
  |-> ##1 (HTRANS == 2) && (HREADY == 0) [*0:$] ##1 (HTRANS == 2) && (HREADY == 1)   // HTRANS stays same untill HREADY is asserted
endproperty 


//-----------------------------------------------------
//      Assertion implementation
//-----------------------------------------------------

// simple transaction
//assert property (single_burst_read_after_write); 
// INCR4 burst
assert property (INCR4_start);         
assert property (INCR4_addr_incr_on_HReady);
assert property (INCR4_addr_incr_on_BUSY);
assert property (INCR4_control_signals_retention);  
// INCR8 burst
assert property (INCR8_start);         
assert property (INCR8_addr_incr_on_HReady);
assert property (INCR8_addr_incr_on_BUSY);
assert property (INCR8_control_signals_retention);

// INCR16 burst
assert property (INCR16_start);         
assert property (INCR16_addr_incr_on_HReady);
assert property (INCR16_addr_incr_on_BUSY);
assert property (INCR16_control_signals_retention);
//undef_INCR_
assert property (undef_INCR_start);             
assert property (undef_INCR_addr_incr_on_HReady);
assert property (undef_INCR_addr_incr_on_BUSY);
assert property (undef_INCR_control_signals_retention);

//lock_transfer
assert property (locked_transfer_2); 
assert property (locked_transfer_1);             
// idle transfer
//assert property (idle_transfer); 

// WRAP_4__assertions
assert property (WRAP4_start); 
assert property (WRAP4_wrap_around_check);      
assert property (WRAP4_addr_incr_on_HReady); 
assert property (WRAP4_addr_incr_on_BUSY);     
assert property (WRAP4_control_signals_retention);   
// WRAP_8__assertions
assert property (WRAP8_start); 
assert property (WRAP8_wrap_around_check);      
assert property (WRAP8_addr_incr_on_BUSY ); 
assert property (WRAP8_addr_incr_on_HReady );     
assert property (WRAP8_control_signals_retention); 
// WRAP_16__assertions
assert property (WRAP16_start); 
assert property (WRAP16_wrap_around_check);      
assert property (WRAP16_addr_incr_on_BUSY ); 
assert property (WRAP16_addr_incr_on_HReady );     
assert property (WRAP16_control_signals_retention);



//-----------------------------------------------------
//      Coverage  implementation
//----------------------------------------------------- 
// simple transaction
//cover property (single_burst_read_after_write); 
// INCR4 burst
cover property (INCR4_start);         
cover property (INCR4_addr_incr_on_HReady);
cover property (INCR4_addr_incr_on_BUSY);
cover property (INCR4_control_signals_retention);  
// INCR8 burst
cover property (INCR8_start);         
cover property (INCR8_addr_incr_on_HReady);
cover property (INCR8_addr_incr_on_BUSY);
cover property (INCR8_control_signals_retention);

// INCR16 burst
cover property (INCR16_start);         
cover property (INCR16_addr_incr_on_HReady);
cover property (INCR16_addr_incr_on_BUSY);
cover property (INCR16_control_signals_retention);
//undef_INCR_
cover property (undef_INCR_start);             
cover property (undef_INCR_addr_incr_on_HReady);
cover property (undef_INCR_addr_incr_on_BUSY);
cover property (undef_INCR_control_signals_retention);

//lock_transfer
cover property (locked_transfer_2); 
cover property (locked_transfer_1);    
// idle transfer         
//cover property (idle_transfer); 
// WRAP_4__assertions
cover property (WRAP4_start); 
cover property (WRAP4_wrap_around_check);      
cover property (WRAP4_addr_incr_on_HReady); 
cover property (WRAP4_addr_incr_on_BUSY);     
cover property (WRAP4_control_signals_retention);   
// WRAP_8__assertions
cover property (WRAP8_start); 
cover property (WRAP8_wrap_around_check);      
cover property (WRAP8_addr_incr_on_BUSY ); 
cover property (WRAP8_addr_incr_on_HReady );     
cover property (WRAP8_control_signals_retention); 
// WRAP__16_assertions
cover property (WRAP16_start); 
cover property (WRAP16_wrap_around_check);      
cover property (WRAP16_addr_incr_on_BUSY ); 
cover property (WRAP16_addr_incr_on_HReady );     
cover property (WRAP16_control_signals_retention); 

endinterface

