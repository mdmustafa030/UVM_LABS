///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Sequence -> Sequencer -> Driver(BFM) -> Interface -> DUT -> Monitor(BFM) -> Packet Reconstruction
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include"uvm_macros.svh"
`include"../sv/yapp_if.sv"
`include"../sv/yapp.svh"
`include "../sv/yapp_router.svh"
`include "../tb/router_tb.sv"
`include "../tb/yapp_seq_lib.sv"
`include "../tb/router_test_lib.sv"
module top_dut;
  bit clock;
  bit reset;
 bit in_suspend;
  yapp_if in0 (clock, reset); 
yapp_router y1(
	.clock(clock),
	.reset(reset),
	//input channel
	.in_data(in0.in_data),
	.in_data_vld(in0.in_data_vld),
	.in_suspend(in0.in_suspend),
	
	// channel 1
	.data_0(),
	.data_vld_0(),
	.suspend_0(1'b0),
	//channel 2
	.data_1(),
	.data_vld_1(),
	.suspend_1(1'b0),
	//channel 3
	.data_2(),
	.data_vld_2(),
	.suspend_2(1'b0)
	);
 // short_incr_payload t1;
 initial begin
    reset <= 1'b1;
    clock <= 1'b1;
   // in0.in_suspend <= 1'b1;
    #50 reset = 1'b0;
    //#50 in0.in_suspend = 1'b0;
  end
    
   always #5 clock = ~clock;
  initial begin
    yapp_vif_config::set(null,"*","vif", in0);
    run_test("short_incr_payload");
  end
endmodule
