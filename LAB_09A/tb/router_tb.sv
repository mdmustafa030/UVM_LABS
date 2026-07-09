class router_tb extends uvm_component;
	`uvm_component_utils(router_tb)
	yapp_env env;
	channel_env env1;
	channel_env env2;
	channel_env env3;
	hbus_env henv;
	router_scoreboard scb;
	router_virtual_sequencer v_sequencer;
	function new(string name="router_tb", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		set_config_int( "*", "recording_detail", 1);
		set_config_int("env1","has_tx",0);
		set_config_int("env2","has_tx",0);
		set_config_int("env3","has_tx",0);
		set_config_int("henv","num_masters",1);
		set_config_int("henv","num_slaves",0);

		super.build_phase(phase);
		env = yapp_env::type_id::create("env",this);
		scb = router_scoreboard::type_id::create("scb",this);
		henv= hbus_env::type_id::create("henv",this);
		env1=channel_env::type_id::create("env1",this);
		env2=channel_env::type_id::create("env2",this);
		env3=channel_env::type_id::create("env3",this);
		v_sequencer= router_virtual_sequencer::type_id::create("v_sequencer",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		v_sequencer.yapp_seqr=env.agent.sequencer;
		v_sequencer.hbus_seqr=henv.masters[0].sequencer;
		env.agent.monitor.item_collected_port.connect(scb.yapp_imp);
		env1.rx_agent.monitor.item_collected_port.connect(scb.chan0_imp);
		env2.rx_agent.monitor.item_collected_port.connect(scb.chan1_imp);
		env3.rx_agent.monitor.item_collected_port.connect(scb.chan2_imp);
	endfunction
endclass
