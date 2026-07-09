class yapp_env extends uvm_env;
	`uvm_component_utils(yapp_env)
	yapp_tx_agent agent;

	function new(string name="yapp_env",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent=yapp_tx_agent::type_id::create("agent",this);
	endfunction

	/*task run_phase(uvm_phase phase);
		super.run_phase(phase);
	//	`uvm_info("Env","I am in Environment",UVM_NONE)
	print();
	endtask*/

	function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info("env","start of simulation phase of env",UVM_HIGH)
	endfunction
endclass
