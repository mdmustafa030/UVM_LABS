# =====================================================
# Lab 1 UVM Makefile
# =====================================================
 
TOP = top
TEST1= base_test
TEST2= test2
all: compile run
 
compile:
	vlib work
	vlog -sv +incdir+../sv $(TOP).sv
 
run_none:   
	vsim -c +UVM_TESTNAME=$(TEST2) +UVM_VERBOSITY=UVM_NONE $(TOP) -do "run -all; quit"

run_low:   
	vsim -c +UVM_TESTNAME=$(TEST2) +UVM_VERBOSITY=UVM_LOW $(TOP) -do "run -all; quit"
 
run_medium:   
	vsim -c +UVM_TESTNAME=$(TEST2) +UVM_VERBOSITY=UVM_MEDIUM $(TOP) -do "run -all; quit"
run_high:   
	vsim -c +UVM_TESTNAME=$(TEST2) +UVM_VERBOSITY=UVM_HIGH $(TOP) -do "run -all; quit"


clean:
	rm -rf work transcript vsim.wlf

