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
//       AHB MASTER MONITOR CLASS
//--------------------------------------------------------------
*/
class ahb_master_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_master_monitor)
  virtual interface ahb_master_if vif;
         
    
  ahb_master_packet pkt;
    
  int packet_number;   // for counting the no of  packets
  // analysis port to send data to scoreboard
  uvm_analysis_port #(ahb_master_packet)  master_mon2scoreboard_port;
  
    
  function new(string name, uvm_component parent);
      super.new(name, parent);
      master_mon2scoreboard_port = new("master_mon2scoreboard_port", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!(master_vif_config::get(this, "", "vif", vif)))
    `uvm_error(get_type_name(), "Failed to get VIF from config DB!")
  endfunction
    
  task run_phase(uvm_phase phase);
    mon_slave();
  endtask
        
  task mon_slave();
    forever begin
      // sync communication with the slave uvc by waiting for HREADY == 1       
      wait (vif.HREADY)
      @(posedge vif.clk)      // captures data at posedge of clk
      #2
      pkt=ahb_master_packet::type_id::create("pkt", this); 
   // trigger transaction at start of packet
   //void'(begin_tr(pkt, "Master_Monitor_Packet"));// For recording of monitor packet 
      pkt.HREADY = vif.HREADY;                                                                                        
	  pkt.HRESP = vif.HRESP;
      pkt.HRESETn = vif.HRESETn;
      pkt.HADDR = vif.HADDR;
      pkt.HWRITE = vif.HWRITE;
      pkt.HSIZE = vif.HSIZE;
      pkt.HBURST = vif.HBURST;
      pkt.HPROT = vif.HPROT;
      pkt.HTRANS = vif.HTRANS;
      pkt.HMASTLOCK = vif.HMASTLOCK;
      pkt.HWDATA = vif.HWDATA;
      // Monitor HRDATA
      pkt.HRDATA = vif.HRDATA;
      master_mon2scoreboard_port.write(pkt);                  
           
     //End transaction recording
     
     //end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet collected no %d :\n%s",packet_number,pkt.sprint()), UVM_NONE)      
      packet_number++;                
    end
  endtask
  
endclass
