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
TEST7= simple_test
TEST8= router_vtest_lib
TEST9= virtual_test
TEST10= coverage_test
all: compile run
 
compile:
	vlib work
	vlog -sv +incdir+../sv  \
	       	+incdir+../../Encrypted_Design/channel/sv \
	       	+incdir+../../Encrypted_Design/hbus/sv \
	       	$(TOP).sv
 
run_none:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_NONE $(TOP) -do "run -all; quit"

run_low:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_LOW $(TOP) -do "run -all; quit"
 
run_medium:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_MEDIUM $(TOP) -do "run -all; quit"
run_high:   
	vsim -c +UVM_TESTNAME=$(TEST4) +UVM_VERBOSITY=UVM_HIGH $(TOP) -do "run -all; quit"

run_full:
	vsim -c +UVM_TESTNAME=$(TEST9) +UVM_VERBOSITY=UVM_FULL $(TOP) -do "run -all; quit"
#	vsim -c +UVM_TESTNAME=$(TEST8) +UVM_VERBOSITY=UVM_FULL +ntb_random_seed_automatic $(TOP) -do "run -all; quit"

run_cov:
	vsim -c -coverage -onfinish stop +UVM_TESTNAME=$(TEST10) +UVM_VERBOSITY=UVM_FULL $(TOP) \
		-do "run -all; coverage save -onexit yapp_cov.ucdb; quit"
	vcover report -html -output yapp_cov_html -details -cvg yapp_cov.ucdb
	xdg-open yapp_cov_html/index.htm
clean:
	rm -rf work transcript vsim.wlf
