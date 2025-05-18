// 64 bit option for AWS labs
-64
-access
+rwc
//-gui
-sv 
-timescale 1ns/1ns
+SVSEED=random
+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH


// include directories
//*** add incdir include directories here
-incdir ../sv/




// compile files
//*** add compile files here
../sv/ahb_slave_pkg.sv
../sv/ahb_slave_if.sv
ahb_slave_top.sv
//+UVM_NO_RELNOTES
