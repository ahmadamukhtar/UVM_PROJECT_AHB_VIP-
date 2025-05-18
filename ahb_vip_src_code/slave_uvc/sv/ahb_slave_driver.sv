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
//         AHB SLAVE DRIVER CLASS
//--------------------------------------------------------------
*/
class ahb_slave_driver extends uvm_driver #(ahb_slave_packet);                                                                           

	`uvm_component_utils(ahb_slave_driver)
	                                                                             
	int packet_number;
	
	virtual interface ahb_slave_if vif;                                                                      
    bit flag;
   //====Covergroup insetion====
	covergroup  slave_if_cov;
		HSEL :    coverpoint  vif.HSELx
		{
		     bins  HSEL_1 = {1};    //======= HSEL always stays 1  for single master and slave communication=======
		   
		}
		HWRITE:    coverpoint  vif.HWRITE;
		HADDR:    coverpoint  vif.HADDR{
		bins addr = {[0:72]};          //=======setting a bin for the addr=========
		}
		HSIZE:    coverpoint  vif.HSIZE{
		bins word_size = {2};      // ========word size=======
		}
		HREADY:    coverpoint  vif.HREADY;
		HBURST:    coverpoint  vif.HBURST;
		HPROT:    coverpoint  vif.HPROT {
		bins default_val = {4'b0011};     //=====Currently HRPOT is set for simple memory slave======
		}
		HTRANS:	coverpoint  vif.HTRANS;
		HMASTLOCK:	coverpoint  vif.HMASTLOCK;
		HWDATA: 	coverpoint  vif.HWDATA {
		bins hwdata_low = {[0:100]};     //=======sclar bin for DATA to be written=======
		}
		//==============Cross to check for combinations of HTRANS and HREADY===========
		HTRANSxHREADY1:	cross HTRANS, HREADY {
		//====checks for HREADY == 1 for each HTRANS except for HTRANS == 1 (BUSY)====
		ignore_bins READY_0 = binsof(HREADY) intersect {0};
		ignore_bins BUSY_1 = binsof(HTRANS) intersect {1}; 
		}
		HTRANSxHREADY2:	cross HTRANS, HREADY {
		//==========checks HREADY == 0 for HTRANS == 1 (BUSY)=============
		ignore_bins READY_1 = binsof(HREADY) intersect {1};
		ignore_bins BUSY_not_1 = binsof(HTRANS) intersect {0,[2:3]}; 
		}
		//===========cross to check combinations of HREADY with HBURST============
		HBURSTxHREADY: cross HBURST, HREADY {
		ignore_bins x1 = binsof(HREADY) intersect {0};
		}
		//==========cross to check that the lock transfer is enabled==========
		HMASLOCKxHREADY: cross HMASTLOCK, HREADY {
		ignore_bins x1 = binsof(HMASTLOCK) intersect {0} && binsof(HREADY) intersect {0};
		ignore_bins x2 = binsof(HMASTLOCK) intersect {1} && binsof(HREADY) intersect {0};
		}
		
	endgroup


	function new(string name, uvm_component parent);                                                    
		super.new(name, parent);   
		slave_if_cov=new();                                                                 
	endfunction: new                                                                                     




	function void connect_phase(uvm_phase phase);                                                                                    
		super.connect_phase(phase);                                                                                                        
		if(!(uvm_config_db#(virtual ahb_slave_if)::get(this, "", "vif", vif)))                                                                                                                            
		begin                                                              
			`uvm_error(get_type_name(), "Failed to get VIF from config DB!")                                                                                              
		end                                                                                  
	endfunction                                                                                                           

	task run_phase(uvm_phase phase);                                                                    
		drive_slave();                                                                              
	endtask                                                                            

	task drive_slave();
		forever                                                                                       
		begin
		//==============Driver waits for the HREADY signal to send a packet or HTRANS == 1 in order to update HTRANS if it was previously BUSY==========            
		    wait (vif.HREADY == 1||vif.HTRANS==1);                                                                       
			@(negedge vif.HCLK)                                                                                                                                                                                    
			begin                                                                              
				seq_item_port.get_next_item(req);  				  
			   vif.HRESETn <= req.HRESETn;      
	     	if( (vif.HRESP == 0) && ( flag == 0 ) )     //====Sends packet if Response is ok (i.e. HRESP == 0)======
				begin		                                                                                                                                                                        				                                                                               
				vif.HSELx <= req.HSELx;                                                                                 
				vif.HADDR <= req.HADDR;                                                                                 
				vif.HWRITE <= req.HWRITE;                                                                                 
				vif.HSIZE <= req.HSIZE;                                                                                 
				vif.HBURST <= req.HBURST;                                                                                 
				vif.HPROT <= req.HPROT;                                                                                 
				vif.HTRANS <= req.HTRANS;                                                                                 
				vif.HMASTLOCK <= req.HMASTLOCK;                                                                                                                                                              
				vif.HWDATA <= req.HWDATA;                                                                                 			                                                                      
			   packet_number++;    
			   `uvm_info(get_type_name(), $sformatf("Packet sent no. %d :\n%s", packet_number,req.sprint()), UVM_NONE) 
				end
				else if ( (vif.HRESP == 1) && ( flag == 0 ) )   //======In case response is error (i.e. HRESP == 1) the sequence is finished with an ideal after two cycle error response========
				begin                              
				//==============1st Cycle Error Response===========                                            
				vif.HSELx <= req.HSELx;                                                                                 
				vif.HADDR <= req.HADDR;                                                                                 
				vif.HWRITE <= req.HWRITE;                                                                                 
				vif.HSIZE <= req.HSIZE;                                                                                 
				vif.HBURST <= req.HBURST;                                                                                 
				vif.HPROT <= req.HPROT;                                                                                 
				vif.HTRANS <= req.HTRANS;                                                                                 
				vif.HMASTLOCK <= req.HMASTLOCK;                                                                                                                                       
				vif.HWDATA <= req.HWDATA;     
				packet_number++;
				  `uvm_info(get_type_name(), $sformatf("Packet sent no. %d :\n%s", packet_number,req.sprint()),UVM_NONE)                                
				@(negedge vif.HCLK)
				//==============1st Cycle Error Response===========
				vif.HRESETn <= 1;                                                                              
				vif.HSELx <= req.HSELx;                                                                                 
				vif.HADDR <= req.HADDR;                                                                                 
				vif.HWRITE <= req.HWRITE;                                                                                 
				vif.HSIZE <= req.HSIZE;                                                                                 
				vif.HBURST <= req.HBURST;                                                                                 
				vif.HPROT <= req.HPROT;                                                                                 
				vif.HTRANS <= 0;                                                                                 
				vif.HMASTLOCK <= req.HMASTLOCK;                                                                                 
				vif.HWDATA <= req.HWDATA;                                                                                                                                                             		            
				flag=1;
					packet_number++;
				  `uvm_info(get_type_name(), $sformatf("Packet sent no. %d :\n%s", packet_number,req.sprint()),UVM_NONE)   
				end
				    slave_if_cov.sample();        			       //=========samples coverage=========
					seq_item_port.item_done();                                                        
                  
				                                                                                 
			end                                                                                                                          
		end                                                                                                                         
	endtask                                                                                   

endclass : ahb_slave_driver                                                                                    
