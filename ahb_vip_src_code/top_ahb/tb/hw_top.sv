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
//                       AHB TOP HW_TOP  MODULE
//-----------------------------------------------------------------------------
*/

module hw_top;
    bit clock;
    bit  [4:0]error_flag;
    bit  [1:0]ready_flag;
   // bit HREADY, HREADYOUT, HRESP;   

//============intantiate interfaces===========
     ahb_master_if master_vif(clock);
     ahb_slave_if slave_vif(clock);



//=========Connect interfac signals of both the UVCs for communication========
	always_comb
	begin
    // master UVC input connections with slave UVC output
	//master_vif.SELx = slave_vif.SELx;
	master_vif.HADDR = slave_vif.HADDR;
	master_vif.HWRITE = slave_vif.HWRITE;
	master_vif.HSIZE = slave_vif.HSIZE;
	master_vif.HBURST = slave_vif.HBURST;
	master_vif.HPROT = slave_vif.HPROT;
	master_vif.HTRANS = slave_vif.HTRANS;
	master_vif.HMASTLOCK = slave_vif.HMASTLOCK;
	master_vif.HWDATA = slave_vif.HWDATA;
	// slave UVC input connections with master UVC output
	master_vif.HREADY = slave_vif.HREADY;
	master_vif.HRESETn = slave_vif.HRESETn;
	master_vif.HRESP = slave_vif.HRESP;
	//master_vif.HREADYOUT = slave_vif.HREADYOUT;
	slave_vif.HRDATA = master_vif.HRDATA;
	// random signals
//	master_vif.HREADY = HREADY;
//	slave_vif.HREADY = HREADY;
//	slave_vif.HREADYOUT = HREADYOUT;
   	end   

//---------------------------------------------
//Kindly place your DUT here
//--------------------------------------------




//------------------------------------
//Clock_Generation
//-----------------------------------
    always
        #5 clock = ~clock;
//-------------------------------
//RTL_Logic
//------------------------------

  int wrap_start_boundary;
  int wrap_end_boundary;
  
  
//------------------------------------------------------
//Error handling logic
//-----------------------------------------------------
//bit  [4:0]error_flag;
//bit  [1:0]ready_flag;
bit  [1:0] past_HTRANS; 
logic flag;


//===========Mimicing the HREADYOUT signal=============
always @(negedge clock)
begin
   
  ready_flag <= $urandom_range(0,3);
  past_HTRANS <= slave_vif.HTRANS;
  

	if( ready_flag == 0  )
	 begin  
	   slave_vif.HREADYOUT <= 0;  
	 end
	else   
	begin    
	  slave_vif.HREADYOUT <= 1; 
	  end
	$display("interested::%d",ready_flag);
end
	
//==========Mimicing/ Randomizing the HRESP signal=======
	always @(negedge  clock)
	begin
	 error_flag = $urandom_range(0,5);
	if(error_flag==0) begin  slave_vif.HRESP=0;  end
	else   begin    slave_vif.HRESP=0; end
	end

//---------------------------------------------------------------------------
// Mimicing the HREADY signal from the interconnect
//---------------------------------------------------------------------------

always_comb
begin
   //#2
   if( past_HTRANS == 1 && (slave_vif.HTRANS==3) )
     slave_vif.HREADY = 1; 
  else if (slave_vif.HTRANS == 1)
    slave_vif.HREADY = 0;
  else 
    slave_vif.HREADY = slave_vif.HREADYOUT;
end

//------------------------------------------------------------------------------------------------------
// Modeling address increment with HREADY signal for INCR type bursts
//------------------------------------------------------------------------------------------------------
always @(negedge clock)
begin
	if( !slave_vif.HREADY)
	begin
	         if (($past(slave_vif.HREADY) == 1) && (slave_vif.HTRANS == 3) && (slave_vif.HBURST == 1 || slave_vif.HBURST == 3 || slave_vif.HBURST == 5 || slave_vif.HBURST == 7))
	         begin   
				slave_vif.HRESETn<=slave_vif.HRESETn;                                                                                                                                                                                  
				slave_vif.HSELx<=slave_vif.HSELx;                             
				slave_vif.HADDR<= $past(slave_vif.HADDR) + 4;                                                                                                        
				slave_vif.HWRITE<=slave_vif.HWRITE;                                                             
				slave_vif.HSIZE<=slave_vif.HSIZE;                                                                              
				slave_vif.HBURST<=slave_vif.HBURST;                      
				slave_vif.HPROT<=slave_vif.HPROT;                                                        
				slave_vif.HTRANS<=slave_vif.HTRANS;                                                                                  
				slave_vif.HMASTLOCK<=	slave_vif.HMASTLOCK;                                                                                                                                              
				slave_vif.HWDATA<=slave_vif.HWDATA;                                                                                                                                                                       
				slave_vif.HRESP<=slave_vif.HRESP;
		     end                    
		   else if (($past(slave_vif.HREADY) == 0) && (slave_vif.HTRANS == 3) && ( slave_vif.HBURST == 1 || slave_vif.HBURST == 3 || slave_vif.HBURST == 5 || slave_vif.HBURST == 7))
		        slave_vif.HRESETn<=slave_vif.HRESETn;                                                                                                                                                                                  
				slave_vif.HSELx<=slave_vif.HSELx;
		        slave_vif.HADDR<= slave_vif.HADDR;
		        slave_vif.HWRITE<=slave_vif.HWRITE;                                                             
				slave_vif.HSIZE<=slave_vif.HSIZE;                                                                              
				slave_vif.HBURST<=slave_vif.HBURST;                      
				slave_vif.HPROT<=slave_vif.HPROT;                                                        
				slave_vif.HTRANS<=slave_vif.HTRANS;                                                                                  
				slave_vif.HMASTLOCK<=	slave_vif.HMASTLOCK;                                                                                                                                              
				slave_vif.HWDATA<=slave_vif.HWDATA;                                                                                                                                                                       
				slave_vif.HRESP<=slave_vif.HRESP;
   end
end
//-----------------------------------------------------------------------------------------------
// Modeling Address increment with HREADY for WRAP type bursts
//-----------------------------------------------------------------------------------------------
always @(negedge clock)
begin
	if( !slave_vif.HREADY)
	begin
	         if (($past(slave_vif.HREADY) == 1) && (slave_vif.HTRANS == 3) && (slave_vif.HBURST == 2 || slave_vif.HBURST == 4 || slave_vif.HBURST == 6 ))
	         begin   
	              if ( $past(slave_vif.HADDR) + 4 < master_vif.wrap_end_boundary)
	              begin
					slave_vif.HRESETn<=slave_vif.HRESETn;                                                                                                                                                                                  
					slave_vif.HSELx<=slave_vif.HSELx;                             
					slave_vif.HADDR<= $past(slave_vif.HADDR) + 4;                                                                                                        
					slave_vif.HWRITE<=slave_vif.HWRITE;                                                             
					slave_vif.HSIZE<=slave_vif.HSIZE;                                                                              
					slave_vif.HBURST<=slave_vif.HBURST;                      
					slave_vif.HPROT<=slave_vif.HPROT;                                                        
					slave_vif.HTRANS<=slave_vif.HTRANS;                                                                                  
					slave_vif.HMASTLOCK<=	slave_vif.HMASTLOCK;                                                                                                                                              
					slave_vif.HWDATA<=slave_vif.HWDATA;                                                                                                                                                                       
					slave_vif.HRESP<=slave_vif.HRESP;
				   end
				   else
				   begin
				    slave_vif.HRESETn<=slave_vif.HRESETn;                                                                                                                                                                                  
					slave_vif.HSELx<=slave_vif.HSELx;                             
					slave_vif.HADDR<= master_vif.wrap_start_boundary;                                                                                                        
					slave_vif.HWRITE<=slave_vif.HWRITE;                                                             
					slave_vif.HSIZE<=slave_vif.HSIZE;                                                                              
					slave_vif.HBURST<=slave_vif.HBURST;                      
					slave_vif.HPROT<=slave_vif.HPROT;                                                        
					slave_vif.HTRANS<=slave_vif.HTRANS;                                                                                  
					slave_vif.HMASTLOCK<=	slave_vif.HMASTLOCK;                                                                                                                                              
					slave_vif.HWDATA<=slave_vif.HWDATA;                                                                                                                                                                       
					slave_vif.HRESP<=slave_vif.HRESP;
				   end
		     end                    
		   else if (($past(slave_vif.HREADY) == 0) && (slave_vif.HTRANS == 3) && ( slave_vif.HBURST == 2 || slave_vif.HBURST == 4 || slave_vif.HBURST == 6))
		        slave_vif.HRESETn<=slave_vif.HRESETn;                                                                                                                                                                                  
				slave_vif.HSELx<=slave_vif.HSELx;
		        slave_vif.HADDR<= slave_vif.HADDR;
		        slave_vif.HWRITE<=slave_vif.HWRITE;                                                             
				slave_vif.HSIZE<=slave_vif.HSIZE;                                                                              
				slave_vif.HBURST<=slave_vif.HBURST;                      
				slave_vif.HPROT<=slave_vif.HPROT;                                                        
				slave_vif.HTRANS<=slave_vif.HTRANS;                                                                                  
				slave_vif.HMASTLOCK<=	slave_vif.HMASTLOCK;                                                                                                                                              
				slave_vif.HWDATA<=slave_vif.HWDATA;                                                                                                                                                                       
				slave_vif.HRESP<=slave_vif.HRESP;
   end
end





endmodule




