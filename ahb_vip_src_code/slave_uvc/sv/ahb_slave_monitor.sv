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
//         AHB SLAVE MONITOR CLASS
//--------------------------------------------------------------
*/
class ahb_slave_monitor extends uvm_monitor;                                                                      

	`uvm_component_utils(ahb_slave_monitor)                                                                    
	
	ahb_slave_packet pkt;  
	
	virtual interface ahb_slave_if vif;                                                                                                     
	int packet_number;
	//=====analysis port to send data to monitor======
    uvm_analysis_port #(ahb_slave_packet) slave_mon2scoreboard_port;                                                                                                            
    
                                                                                                  
    
	function new(string name, uvm_component parent);                                                                      
		super.new(name, parent);                                                                         
		slave_mon2scoreboard_port = new("slave_mon2scoreboard_port", this);                                                                                                            
	endfunction                                                                                    

	function void connect_phase(uvm_phase phase);                                                                          
		super.connect_phase(phase);                                                                                                     
		if(!(uvm_config_db#(virtual ahb_slave_if)::get(this, "", "vif", vif)))                                                                           
		begin                                                                       
			`uvm_error(get_type_name(), "Failed to get VIF from config DB!")                                                                     
		end                                                                  
	endfunction                                                                                    
    
	task run_phase(uvm_phase phase);                                                                               
		mon_slave();                                                                 
	endtask                                                                                  
        
	task mon_slave();                                                                    
		forever                                                           
		begin                    
		   //===========Monitor only sends packet when HREADY == 1 to prevent redundant packets at the console and in scoreboard=========                                               
		    wait (vif.HREADY)
			                                                                                        
			@(posedge vif.HCLK)                                                                                          
			#2                                                                                            
			// trigger transaction at start of packet                                                                                                            
		//void'(begin_tr(pkt, "AHB_Slave_Monitor_Packet"));// For recording of monitor packet                                                                                                              
			pkt = ahb_slave_packet::type_id::create("pkt", this); 
			 pkt.HREADYOUT = vif.HREADYOUT;                                                                                         
			 pkt.HRESP = vif.HRESP;                                                                                                         
			 pkt.HRDATA = vif.HRDATA; 
			 pkt.HREADY = vif.HREADY; 
             pkt.HRESETn = vif.HRESETn;
             pkt.HADDR = vif.HADDR;
             pkt.HWRITE = vif.HWRITE;
             pkt.HSIZE = vif.HSIZE;
             pkt.HBURST = vif.HBURST;
             pkt.HPROT = vif.HPROT;
             pkt.HTRANS = vif.HTRANS;
             pkt.HMASTLOCK = vif.HMASTLOCK;
             pkt.HWDATA = vif.HWDATA;
			 slave_mon2scoreboard_port.write(pkt);              //data goes from spi to scoreboard                                                                                                 
			// End transaction recording                                                                            
		//end_tr(pkt);                                                                                                   
		`uvm_info(get_type_name(), $sformatf("Packet collected no. %d :\n%s",packet_number, pkt.sprint()), UVM_NONE)
		packet_number++;  
		end                                                                                                                      
	endtask                                                                                                          
    
endclass : ahb_slave_monitor                                                                                          
