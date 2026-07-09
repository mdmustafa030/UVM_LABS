class router_virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(router_virtual_sequencer)
	 
//	channel_rx_sequencer chan_seqr;
	 hbus_master_sequencer hbus_seqr;
	 yapp_tx_sequencer yapp_seqr;

	 function new(string name="router_virtual_sequencer", uvm_component parent=null);
		 super.new(name,parent);
	 endfunction

 endclass
