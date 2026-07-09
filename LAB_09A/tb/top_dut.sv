///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include"uvm_macros.svh"
`include"../sv/yapp_if.sv"
`include"../sv/yapp.svh"
`include "../sv/yapp_router.svh"
// channel include
`include "../../Encrypted_Design/channel/sv/channel_if.sv"
`include "../../Encrypted_Design/channel/sv/channel.svh"
// hbus channel
`include "../../Encrypted_Design/hbus/sv/hbus_if.sv"
`include "../../Encrypted_Design/hbus/sv/hbus_pkg.svp"
import hbus_pkg::*;
`include "../sv/router_scoreboard.sv"
`include "router_virtual_sequencer.sv"
`include "router_virtual_seqs.sv"

`include "../tb/router_tb.sv"
`include "../tb/yapp_seq_lib.sv"
`include "../tb/router_test_lib.sv"
`include "router_vtest_lib.sv"
module top_dut;
  bit clock;
  bit reset;
 bit error;
  yapp_if in0 (clock, reset); 
  hbus_if hif(clock,reset);
  channel_if chn1(clock,reset);
  channel_if chn2(clock,reset);
  channel_if chn3(clock,reset);

yapp_router y1(
	.clock(clock),
	.reset(reset),
	.error(error),
	//input channel
	.in_data(in0.in_data),
	.in_data_vld(in0.in_data_vld),
	.in_suspend(in0.in_suspend),
	
	// channel 1
	.data_0(chn1.data),
	.data_vld_0(chn1.data_vld),
	.suspend_0(chn1.suspend),
	//channel 2
	.data_1(chn2.data),
	.data_vld_1(chn2.data_vld),
	.suspend_1(chn2.suspend),
	//channel 3
	.data_2(chn3.data),
	.data_vld_2(chn3.data_vld),
	.suspend_2(chn3.suspend),

	.haddr(hif.haddr),
	.hdata(hif.hdata_w),
	.hen(hif.hen),
	.hwr_rd(hif.hwr_rd)
	);
 // short_incr_payload t1;
 initial begin
	 #1;
    reset = 1'b1;
    clock = 1'b1;
   // in0.in_suspend <= 1'b1;
    #50 reset = 1'b0;
    //#50 in0.in_suspend = 1'b0;
  end
    
   always #5 clock = ~clock;
initial begin

  yapp_vif_config::set(null,"*","vif",in0);

  hbus_vif_config::set(null,"*","vif",hif);

  channel_vif_config::set(null,"*.env1*","vif",chn1);

  channel_vif_config::set(null,"*.env2*","vif",chn2);

  channel_vif_config::set(null,"*.env3*","vif",chn3);

  run_test("router_vtest_lib");

end
endmodule
