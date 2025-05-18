// 64 bit option for AWS labs
-64
-access
+rwc
//-gui
-sv 
-timescale 1ns/1ns
+SVSEED=random
+UVM_TESTNAME=Test_case7
+UVM_VERBOSITY=UVM_HIGH



// include directories
//*** add incdir include directories here
-incdir ../../slave_uvc/sv/
-incdir ../../master_uvc/sv/

-incdir ../sv/




// compile files
//*** add compile files here
../../master_uvc/sv/ahb_master_pkg.sv
../../master_uvc/sv/ahb_master_if.sv
../../slave_uvc/sv/ahb_slave_pkg.sv
../../slave_uvc/sv/ahb_slave_if.sv

hw_top.sv
ahb_top.sv
