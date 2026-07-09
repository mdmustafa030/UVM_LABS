class router_tb extends uvm_component;
	`uvm_component_utils(router_tb)
	/*
	What is a UVC in UVM?

A UVC (Universal Verification Component) is a reusable protocol-specific verification block built using UVM. It typically contains an agent (driver, monitor, sequencer), protocol sequences, configuration objects, and coverage components. A UVC encapsulates all verification functionality for a particular interface or protocol, enabling reuse across multiple projects and testbenches.

For your router labs:

YAPP UVC  -> Packet Generation
HBUS UVC  -> Register Access
Channel UVC -> Output Packet Monitoring

These three UVCs together form the complete router verification environment.
	*/
	yapp_env env;
	channel_env env1;
	channel_env env2;
	channel_env env3;
	hbus_env henv;
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
		henv= hbus_env::type_id::create("henv",this);
		env1=channel_env::type_id::create("env1",this);
		env2=channel_env::type_id::create("env2",this);
		env3=channel_env::type_id::create("env3",this);
	endfunction
endclass
