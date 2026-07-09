class yapp_tx_monitor extends uvm_monitor;
	`uvm_component_utils(yapp_tx_monitor)
	function new(string name="yapp_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info("mon","start of simulation phase of monitor",UVM_HIGH)
	endfunction
	task run_phase(uvm_phase phase);
		`uvm_info("Monitor","I am in Monitor",UVM_LOW)
	endtask
endclass
