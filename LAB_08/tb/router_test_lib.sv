class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	
	//yapp_env env;
	router_tb router;
	function new(string name="base_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
//	  uvm_config_wrapper::set(this, "router.env.agent.sequencer.run_phase","default_sequence",yapp_5_packets::type_id::get());
		super.build_phase(phase);
	//	env=yapp_env::type_id::create("env",this);
	        router=router_tb::type_id::create("router",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
	phase.raise_objection(this);	
		phase.phase_done.set_drain_time(this, 200ns);
		#1000ns;
		phase.drop_objection(this);
	endtask
endclass


class test2 extends base_test;
	`uvm_component_utils(test2)
	function new(string name="test2",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass



class short_packet_test extends base_test;
	`uvm_component_utils(short_packet_test)
	function new(string name="short_packet_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		yapp_packet::type_id::set_type_override(
         short_yapp_packet::get_type()
      );
      	super.build_phase(phase);
	endfunction
endclass


class set_config_test extends base_test;
	`uvm_component_utils(set_config_test)
	function new(string name="set_config_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
                  super.build_phase(phase);
`uvm_info("TEST",
          "Setting PASSIVE",
          UVM_LOW)
                set_config_int("env.agent","is_active",UVM_PASSIVE);
	endfunction

endclass

class short_incr_payload extends base_test;
	`uvm_component_utils(short_incr_payload)
function new(string name ="short_incr_payload", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(),"Short_incr_payload test",UVM_LOW)
	  uvm_config_wrapper::set(this, "router.env.agent.sequencer.run_phase","default_sequence",yapp_incr_payload_seq::type_id::get());
	  yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
	endfunction
endclass



class exhaustive_seq_test extends base_test;

   `uvm_component_utils(exhaustive_seq_test)

   yapp_seq_lib seq;

   function new(
      string name="exhaustive_seq_test",
      uvm_component parent=null
   );
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      seq = yapp_seq_lib::type_id::create("seq");

      seq.selection_mode = UVM_SEQ_LIB_RANDC;

      seq.min_random_count = 8;
      seq.max_random_count = 10;

      uvm_config_db #(uvm_sequence_base)::set(
         this,
         "router.env.agent.sequencer.run_phase",
         "default_sequence",
         seq
      );

      yapp_packet::type_id::set_type_override(
         short_yapp_packet::get_type()
      );

   endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
	   super.end_of_elaboration_phase(phase);
	   seq.print();
//	   `uvm_info(get_type_name(),seq.sprint(),UVM_LOW)
   endfunction

endclass



class simple_test extends base_test;

	`uvm_component_utils(simple_test)

function new(string name="simple_test", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	
yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
 uvm_config_wrapper::set(this, "router.env.agent.sequencer.run_phase","default_sequence",yapp_012_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 uvm_config_wrapper::set(this, "router.env3.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());
 super.build_phase(phase);
endfunction
endclass
