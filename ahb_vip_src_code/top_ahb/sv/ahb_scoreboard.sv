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
//                  AHB SLAVE SCOREBOARD
//-----------------------------------------------------------------------------
*/




class ahb_scorboard extends uvm_scoreboard;
    `uvm_component_utils(ahb_scorboard)
    
     uvm_tlm_analysis_fifo  #(ahb_master_packet) master_in_fifo;
     uvm_tlm_analysis_fifo  #(ahb_slave_packet) slave_in_fifo;
     int num_error;

   
   ahb_master_packet   master_pkt;
   ahb_slave_packet slave_pkt;
   
   bit [7:0] mem[1024];            // memory to store the incoming data
   int read_data;
   bit [31:0]addr;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        master_in_fifo = new("master_in_fifo", this);
        slave_in_fifo = new("slave_in_fifo", this);
    endfunction
    
   // /*
    task run_phase(uvm_phase phase);
     forever 

     begin
         slave_in_fifo.get_peek_export.get(slave_pkt);
          //==============Modeling the read and write phenomenon of the MASTER in SLAVE===========
          if(slave_pkt.HRESETn == 1   &&   slave_pkt.HREADY == 1 && slave_pkt.HTRANS != 2)
          begin
            if (slave_pkt.HWRITE == 1 )
            begin
               if(slave_pkt.HTRANS  != 0)
               begin
               		if((slave_pkt.HADDR==0) && (slave_pkt.HBURST != 1 || slave_pkt.HBURST != 3 || slave_pkt.HBURST != 5|| slave_pkt.HBURST != 7))
              		begin
               		mem[addr] = slave_pkt.HWDATA[7:0];
               		mem[addr+1] = slave_pkt.HWDATA[15:8];
               		mem[addr+2] = slave_pkt.HWDATA[23:16];
              		mem[addr+3] = slave_pkt.HWDATA[31:24];
               		addr = slave_pkt.HADDR;
               		end
               		else 
              		begin
                	mem[slave_pkt.HADDR-4] = slave_pkt.HWDATA[7:0];
                	mem[slave_pkt.HADDR+1-4] = slave_pkt.HWDATA[15:8];
                	mem[slave_pkt.HADDR+2-4] = slave_pkt.HWDATA[23:16];
                	mem[slave_pkt.HADDR+3-4] = slave_pkt.HWDATA[31:24];
                	addr = slave_pkt.HADDR;
               		end
               end
               else begin
               mem[addr] = slave_pkt.HWDATA[7:0];
               mem[addr+1] = slave_pkt.HWDATA[15:8];
               mem[addr+2] = slave_pkt.HWDATA[23:16];
               mem[addr+3] = slave_pkt.HWDATA[31:24];
               end
            end
            else if ( slave_pkt.HWRITE == 0 && slave_pkt.HRESETn == 1 && slave_pkt.HTRANS != 2)
            begin
            
            master_in_fifo.get_peek_export.get(master_pkt);
          
             if (slave_pkt.HTRANS !=0)
             begin
             	if ((slave_pkt.HADDR==0) && (slave_pkt.HBURST != 1 || slave_pkt.HBURST != 3 || slave_pkt.HBURST != 5|| slave_pkt.HBURST != 7))
             	begin
              		read_data[7:0] = mem[addr];
              		read_data[15:8] = mem[addr+1];
              		read_data[23:16] = mem[addr+2];
              		read_data[31:24] = mem[addr+3];
              		addr = slave_pkt.HADDR;		
              		compare();
              	end
              	else
              	begin
              		read_data[7:0] = mem[slave_pkt.HADDR-4];
              		read_data[15:8] = mem[slave_pkt.HADDR+1-4];
              		read_data[23:16] = mem[slave_pkt.HADDR+2-4];
              		read_data[31:24] = mem[slave_pkt.HADDR+3-4];
              		addr = slave_pkt.HADDR;		
              		compare();
              	end
             end
             else
             begin
                read_data[7:0] = mem[addr];
              	read_data[15:8] = mem[addr+1];
              	read_data[23:16] = mem[addr+2];
              	read_data[31:24] = mem[addr+3];
              	compare();
             end
            end
          end
      end           
           
    endtask
    
    
    
   //=======================Compare task to compare the read values from memory and from the MASTER UVC================ 
    task compare();
       $display("Read data is %0d", read_data);
       $display("Master HRDATA is %0d",  slave_pkt.HRDATA);
      if (  read_data ==  slave_pkt.HRDATA )
        `uvm_info("SCB", "The data has been read correctly...!", UVM_MEDIUM)
     else 
     begin
       `uvm_info("SCB", "The data read is wrong...!", UVM_MEDIUM)
       num_error++;
     end
    endtask
    
    
  
    //==============Reports the total number of errors in the report phase of the scoreboard===========
   function void report_phase(uvm_phase phase);
     `uvm_info("SCB",$sformatf("The total number of errors reported are: %d", num_error),UVM_LOW)
   endfunction
  
endclass
