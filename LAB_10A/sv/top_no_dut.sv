///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include"uvm_macros.svh"
`include"../sv/yapp_if.sv"
`include"../sv/yapp.svh"
`include "../sv/router_tb.sv"
`include "../sv/router_test_lib.sv"
module top_no_dut;
  bit clock;
  bit reset;
  bit in_suspended;
  yapp_if in0 (clock, reset);
 // short_incr_payload t1;
 initial begin
    reset <= 1'b1;
    clock <= 1'b1;
    in_suspended <= 1'b1;
    #50 reset = 1'b0;
    #50 in_suspended = 1'b0;
  end
    
   always #5 clock = ~clock;
  initial begin
    yapp_vif_config::set(null,"*","vif", in0);
    run_test("short_incr_payload");
  end
endmodule
