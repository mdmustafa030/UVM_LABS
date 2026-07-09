import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../sv/yapp.svh"
`include "yapp_seq_lib.sv"
`include "yapp_test_lib.sv"
module top;
  
initial begin 
    run_test("exhaustive_seq_test");
  end

endmodule
