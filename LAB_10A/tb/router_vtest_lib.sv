class router_vtest_lib extends base_test;
	`uvm_component_utils(router_vtest_lib)

	function new(string name="router_vtest_lib",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
  super.build_phase(phase);
	yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
	 uvm_config_wrapper::set(this, "router.env1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env3.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
  uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",router_simple_vseq::type_id::get());

	endfunction
endclass

class virtual_test extends base_test;
	`uvm_component_utils(virtual_test)
	function new(string name="virtual_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
  uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",virtual_sequences::type_id::get());
 // uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",max_pkt_seq::type_id::get());
 	 uvm_config_wrapper::set(this, "router.env1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env3.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
  super.build_phase(phase);
  endfunction
  endclass
