class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);
	`uvm_component_utils(yapp_tx_sequencer)
	function new(string name = "yapp_tx_sequencer", uvm_component parent=null);
		super.new(name,parent);
		`uvm_info("Sequencer Class","Constructor",UVM_LOW)
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info("seqsr","start of simulation phase of sequencer",UVM_HIGH)
	endfunction
endclass
