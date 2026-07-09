import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../sv/yapp.svh"

module top;

  yapp_env env;

  initial begin
    env = new("env", null);
  end

  initial begin
  /*
 build_phase
      ↓
connect_phase
      ↓
start_of_simulation
      ↓
run_phase
      ↓
sequencer enters run_phase
      ↓
checks config DB
      ↓
finds default_sequence
      ↓
creates yapp_5_packets
      ↓
starts yapp_5_packets
      ↓
sequence generates transactions
      ↓
driver drives DUT



instead of using this in the sequencer run-phase 
task run_phase(uvm_phase phase);

   yapp_5_packets seq;

   seq = yapp_5_packets::type_id::create("seq");

   seq.start(env.agent.sequencer);

endtask
we directly configure it and set the default sequence uvm does this automatically.
	 */ 



	  uvm_config_wrapper::set(null, "env.agent.sequencer.run_phase","default_sequence",yapp_5_packets::type_id::get());
    run_test();
  end

endmodule
