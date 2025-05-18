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
//       AHB MASTER DRIVER CLASS
//--------------------------------------------------------------
*/


class ahb_master_driver extends uvm_driver #(ahb_master_packet);
  `uvm_component_utils(ahb_master_driver)
  virtual interface ahb_master_if vif;
  int packet_number;
  //========= coverage group==============
  covergroup  ahb_slav_cov;
  	coverpoint vif.HREADY;
  	coverpoint vif.HRESP {
  	bins resp_1 = {0};
  	}
  	coverpoint vif.HRDATA {
  	bins hrdata_low = {[0:100]};
  	}
  endgroup
 
  function new(string name, uvm_component parent);
      super.new(name, parent);
      ahb_slav_cov=new();
  endfunction: new

  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(!(master_vif_config::get(this, "", "vif", vif)))
      `uvm_error(get_type_name(), "Failed to get VIF from config DB!")
  endfunction

  task run_phase(uvm_phase phase);
      master_send();
  endtask

  task master_send();
      forever begin      
        //=======Sync communiation by creating a model that acts like the slave dut=======
        wait(vif.HREADY == 1 && vif.HRESETn == 1 && vif.HTRANS != 0)    // only provide HRDATA at this condition
        
        @(negedge vif.clk)    // drives at negedge when above conditions meet
        #2
        
        seq_item_port.get_next_item(req);
        
        if (vif.past_HWRITE == 0)
        begin
           
            
           vif.HRDATA<= req.HRDATA; 
           ahb_slav_cov.sample();       
        // trigger transaction at start of packet
           void'(begin_tr(req, "AHB_MASTER_Driver_Packet"));// For recording of driver packet
           // vif.HREADY<= req.HREADY;
           //vif.HRESP<= req.HRESP;
            //$display("HRDATA is as %d", req.HRDATA);
        
        // End transaction recording
           end_tr(req);
        
           seq_item_port.item_done();
           packet_number++;
           `uvm_info(get_type_name(), $sformatf("Packet no. %d by driver of master uvc sent:\n%s", packet_number, req.sprint()), UVM_NONE)
       end   
      end
        
    endtask
              

  
 
endclass
