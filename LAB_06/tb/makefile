# =====================================================
# Lab 1 UVM Makefile
# =====================================================
 
TOP = top_dut
TEST1= base_test
TEST2= test2
TEST3= short_packet_test
TEST4= set_config_test
TEST5= short_incr_payload
TEST6= exhaustive_seq_test
all: compile run
 
compile:
	vlib work
	vlog -sv +incdir+../sv $(TOP).sv
 
run_none:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_NONE $(TOP) -do "run -all; quit"

run_low:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_LOW $(TOP) -do "run -all; quit"
 
run_medium:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_MEDIUM $(TOP) -do "run -all; quit"
run_high:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_HIGH $(TOP) -do "run -all; quit"

run_full:
	vsim -c +UVM_TESTNAME=$(TEST1) +UVM_VERBOSITY=UVM_HIGH $(TOP) -do "run -all; quit"

clean:
	rm -rf work transcript vsim.wlf
