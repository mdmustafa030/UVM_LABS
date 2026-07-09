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
  //uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",max_pkt_seq::type_id::get());
 	 uvm_config_wrapper::set(this, "router.env1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env3.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
  super.build_phase(phase);
  endfunction
  endclass


  class coverage_test extends base_test;
	`uvm_component_utils(coverage_test)
	function new(string name="coverage_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
  //uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",coverage_seq::type_id::get());
  //uvm_config_wrapper::set(this, "router.v_sequencer.run_phase","default_sequence",max_pkt_seq::type_id::get());
 	 uvm_config_wrapper::set(this, "router.env1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_long_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_long_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env3.rx_agent.sequencer.run_phase","default_sequence",channel_rx_long_resp_seq::type_id::get());
  super.build_phase(phase);
  endfunction
task run_phase(uvm_phase phase);
    coverage_seq  seq1;
    max_pkt_seq   seq2;
    virtual_sequences seq3;

    phase.raise_objection(this, "coverage_test running two sequences sequentially");

    seq1 = coverage_seq::type_id::create("seq1");
    seq1.starting_phase = phase;     
    seq1.start(router.v_sequencer);

    seq2 = max_pkt_seq::type_id::create("seq2");
    seq2.starting_phase = phase;     
    seq2.start(router.v_sequencer);

    seq3 = virtual_sequences::type_id::create("seq2");
    seq3.starting_phase = phase;     
    seq3.start(router.v_sequencer);


    phase.drop_objection(this, "coverage_test finished both sequences");
endtask
  endclass
