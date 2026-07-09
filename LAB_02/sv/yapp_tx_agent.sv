class yapp_tx_agent extends uvm_agent;
	`uvm_component_utils(yapp_tx_agent)
	
	yapp_tx_monitor monitor;
	yapp_tx_sequencer sequencer;
	yapp_tx_driver driver;
	uvm_active_passive_enum is_active=UVM_ACTIVE;
	function new(string name="yapp_agent",uvm_component parent=null);
		super.new(name,parent);
	endfunction



	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor= yapp_tx_monitor::type_id::create("monitor",this);
		if(is_active == UVM_ACTIVE) begin
		driver=yapp_tx_driver::type_id::create("driver",this);
		sequencer=yapp_tx_sequencer::type_id::create("sequencer",this);
	        end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE)
		driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction
endclass
