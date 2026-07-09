import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../sv/yapp.svh"
`include "yapp_test_lib.sv"
module top;
 /*
 BUILDING TESTBENCH
──────────────────────────────

build_phase
      ↓
connect_phase
      ↓
end_of_elaboration_phase
      ↓
start_of_simulation_phase

SIMULATION EXECUTION
──────────────────────────────

pre_reset_phase
      ↓
reset_phase
      ↓
post_reset_phase
      ↓
pre_configure_phase
      ↓
configure_phase
      ↓
post_configure_phase
      ↓
pre_main_phase
      ↓
main_phase
      ↓
post_main_phase
      ↓
pre_shutdown_phase
      ↓
shutdown_phase
      ↓
post_shutdown_phase

SIMULATION ANALYSIS
──────────────────────────────

extract_phase
      ↓
check_phase
      ↓
report_phase
      ↓
final_phase
 */ 
initial begin 
    run_test();
  end

endmodule
