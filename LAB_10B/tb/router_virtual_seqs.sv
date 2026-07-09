class router_simple_vseq extends uvm_sequence;
	`uvm_object_utils(router_simple_vseq)
	function new(string name="router_simple_vseq");
		super.new(name);

`uvm_info("DBG","Inside rsvseq", UVM_LOW)
	endfunction
	hbus_small_packet_seq small_pkt_seq; //for accepting small pcaktes (<21)
	hbus_read_max_pkt_seq read_max_seq; //reading the maxpktsize register 
	yapp_012_seq yapp_seq; //consecutive packets with addresses 0-1-2
	hbus_set_default_regs_seq default_reg_seq; //setting router to accept larger packets

	`uvm_declare_p_sequencer(router_virtual_sequencer)

task body();
    //`uvm_info("DBG","Inside rsvseq body", UVM_LOW)
    
    // --- DEBUG: Check starting_phase before raising objection ---
    if (starting_phase == null) begin
      `uvm_info("DBG", "starting_phase is null! Objection will NOT be raised.", UVM_LOW)
    end else begin
      `uvm_info("DBG", "starting_phase is valid. Raising objection.", UVM_LOW)
      starting_phase.raise_objection(this, get_type_name());
    end

    // --- DEBUG: Verify all sequencer handles from p_sequencer ---
    if (p_sequencer == null)
      `uvm_fatal("DBG", "p_sequencer is completely null! Check your virtual sequencer assignment.")
    else
      `uvm_info("DBG", "p_sequencer handle is valid.", UVM_LOW)

    if (p_sequencer.hbus_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.hbus_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.hbus_seqr handle is valid.", UVM_LOW)
      
    if (p_sequencer.yapp_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.yapp_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.yapp_seqr handle is valid.", UVM_LOW)


    //--------------------------------------------------
    // Set router for small packets (<21)
    //--------------------------------------------------
    /*`uvm_info("DBG", "Creating small_pkt_seq...", UVM_LOW)
    small_pkt_seq = hbus_small_packet_seq::type_id::create("small_pkt_seq");
    
    if (small_pkt_seq == null) `uvm_fatal("DBG", "small_pkt_seq failed to create!")

    `uvm_info("DBG", "Calling start on small_pkt_seq...", UVM_LOW)
small_pkt_seq.starting_phase = this.starting_phase;
    small_pkt_seq.start(p_sequencer.hbus_seqr,this);
    `uvm_info("DBG", "small_pkt_seq finished successfully.", UVM_LOW)


    //--------------------------------------------------
    // Read MAXPKTSIZE register
    //--------------------------------------------------
    `uvm_info("DBG", "Creating read_max_seq...", UVM_LOW)
    read_max_seq = hbus_read_max_pkt_seq::type_id::create("read_max_seq");
    
    if (read_max_seq == null) `uvm_fatal("DBG", "read_max_seq failed to create!")

    `uvm_info("DBG", "Calling start on read_max_seq...", UVM_LOW)
read_max_seq.starting_phase = this.starting_phase;
    read_max_seq.start(p_sequencer.hbus_seqr,this);
    `uvm_info("DBG", "read_max_seq finished successfully.", UVM_LOW)

*/
    //--------------------------------------------------
    // Send 6 packets: 0,1,2,0,1,2
    //--------------------------------------------------
    repeat(8) begin
      `uvm_info("DBG", "Creating yapp_seq...", UVM_LOW)
      yapp_seq = yapp_012_seq::type_id::create("yapp_seq");
      
      if (yapp_seq == null) `uvm_fatal("DBG", "yapp_seq failed to create!")

      `uvm_info("DBG", "Calling start on yapp_seq...", UVM_LOW)
yapp_seq.starting_phase = this.starting_phase;
      yapp_seq.start(p_sequencer.yapp_seqr,this);
      `uvm_info("DBG", "yapp_seq finished successfully.", UVM_LOW)
    end

/*
    //--------------------------------------------------
    // Set router for large packets (<64)
    //--------------------------------------------------
    `uvm_info("DBG", "Creating default_reg_seq...", UVM_LOW)
    default_reg_seq = hbus_set_default_regs_seq::type_id::create("default_reg_seq");
    
    if (default_reg_seq == null) `uvm_fatal("DBG", "default_reg_seq failed to create!")

    `uvm_info("DBG", "Calling start on default_reg_seq...", UVM_LOW)
default_reg_seq.starting_phase = this.starting_phase;
    default_reg_seq.start(p_sequencer.hbus_seqr,this);
    `uvm_info("DBG", "default_reg_seq finished successfully.", UVM_LOW)


    //--------------------------------------------------
    // Read MAXPKTSIZE register
    //--------------------------------------------------
    `uvm_info("DBG", "Creating read_max_seq2...", UVM_LOW)
    read_max_seq = hbus_read_max_pkt_seq::type_id::create("read_max_seq2");

    `uvm_info("DBG", "Calling start on read_max_seq2...", UVM_LOW)
read_max_seq.starting_phase = this.starting_phase;
    read_max_seq.start(p_sequencer.hbus_seqr,this);
    `uvm_info("DBG", "read_max_seq2 finished successfully.", UVM_LOW)


    //--------------------------------------------------
    // Send random 6 packets
    //--------------------------------------------------
//--------------------------------------------------
    // Send random 6 packets
    //--------------------------------------------------
    `uvm_info("DBG", "Starting uvm_do_on loop...", UVM_LOW)
    repeat(6) begin
      yapp_packet pkt;
      `uvm_info("DBG", "Inside of uvm_do_on loop.", UVM_LOW)
      
      // Use uvm_do_on to target the physical sequencer
      `uvm_do_on(pkt, p_sequencer.yapp_seqr)
      
    end
    `uvm_info("DBG", "uvm_do_on loop finished.", UVM_LOW)

*/
    // --- DEBUG: Check starting_phase before dropping objection ---
    if (starting_phase != null) begin
      `uvm_info("DBG", "Dropping objection...", UVM_LOW)
      starting_phase.drop_objection(this, get_type_name());
    end

  endtask
endclass

class virtual_sequences extends uvm_sequence;
	`uvm_object_utils(virtual_sequences)
	
	function new(string name="virtual_sequences");
		super.new(name);
	endfunction
      //  yapp_with_bad_size_seq yapp_seq; 
	yapp_012_seq yapp_seq; //consecutive packets with addresses 0-1-2
	 hbus_set_yapp_regs_seq config_seq;
 	`uvm_declare_p_sequencer(router_virtual_sequencer)
	
	task body();
	`uvm_info(get_type_name(),"Entered in Virtual Sequences",UVM_LOW)
    // --- DEBUG: Check starting_phase before raising objection ---
    if (starting_phase == null) begin
      `uvm_info("DBG", "starting_phase is null! Objection will NOT be raised.", UVM_LOW)
    end else begin
      `uvm_info("DBG", "starting_phase is valid. Raising objection.", UVM_LOW)
      starting_phase.raise_objection(this, get_type_name());
    end

    // --- DEBUG: Verify all sequencer handles from p_sequencer ---
    if (p_sequencer == null)
      `uvm_fatal("DBG", "p_sequencer is completely null! Check your virtual sequencer assignment.")
    else
      `uvm_info("DBG", "p_sequencer handle is valid.", UVM_LOW)

    if (p_sequencer.hbus_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.hbus_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.hbus_seqr handle is valid.", UVM_LOW)
      
    if (p_sequencer.yapp_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.yapp_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.yapp_seqr handle is valid.", UVM_LOW)

    //--------------------------------------------------
    // Setting up the router 
    //--------------------------------------------------
    repeat(11)
    begin
    `uvm_info("DBG", "Setting the Router ", UVM_LOW)
    config_seq = hbus_set_yapp_regs_seq::type_id::create("config_seq");
    
    if (config_seq == null) `uvm_fatal("DBG", "Config_seq failed to create!")

    `uvm_info("DBG", "Calling start on Config_seq...", UVM_LOW)
  // Set the desired values BEFORE starting the sequence
config_seq.starting_phase = this.starting_phase;
              if (!config_seq.randomize() with { max_pkt_reg inside {[10:30]}; enable_reg dist{1:=2 , 0:=3}; })
            `uvm_fatal("VSEQ", "Config randomization failed")                 //config_seq.enable_reg  = 1;  // Enable the router
                 config_seq.start(p_sequencer.hbus_seqr, this); 
`uvm_info("DBG", "config_seq finished successfully.", UVM_LOW)
// In your virtual_sequences
    uvm_config_db#(int)::set(null, "*", "MAX_PKT_REG", config_seq.max_pkt_reg);   
    `uvm_info("STATUS",$sformatf("Configured The Router with  MAX_PKT_LEN= %0d , ENABLE= %0d",config_seq.max_pkt_reg,config_seq.enable_reg),UVM_LOW)

    //----------------------------------------------------------
    //Starting to the packets with GOOD,BAD PARITY
    //----------------------------------------------------------
repeat(2) begin
    // Runs 'yapp_seq' specifically on the 'p_sequencer.yapp_seqr' handle
    `uvm_do_on(yapp_seq, p_sequencer.yapp_seqr)
    `uvm_info(get_type_name(),"Calling the yapp_with_bad_size_seq from virtual_sequences",UVM_LOW)
end
end
    // --- DEBUG: Check starting_phase before dropping objection ---
    if (starting_phase != null) begin
      `uvm_info("DBG", "Dropping objection...", UVM_LOW)
      starting_phase.drop_objection(this, get_type_name());
    end

endtask
endclass


class max_pkt_seq extends uvm_sequence;
	`uvm_object_utils(max_pkt_seq)
	function new(string name="max_pkt_seq");
		super.new(name);
	endfunction
         yapp_with_packet_size_seq yapp_seq; 
	 hbus_set_yapp_regs_seq config_seq;
 	`uvm_declare_p_sequencer(router_virtual_sequencer)
	
	task body();
	`uvm_info(get_type_name(),"Entered in Max packet Sequence",UVM_LOW)
    // --- DEBUG: Check starting_phase before raising objection ---
    if (starting_phase == null) begin
      `uvm_info("DBG", "starting_phase is null! Objection will NOT be raised.", UVM_LOW)
    end else begin
      `uvm_info("DBG", "starting_phase is valid. Raising objection.", UVM_LOW)
      starting_phase.raise_objection(this, get_type_name());
    end

    // --- DEBUG: Verify all sequencer handles from p_sequencer ---
    if (p_sequencer == null)
      `uvm_fatal("DBG", "p_sequencer is completely null! Check your virtual sequencer assignment.")
    else
      `uvm_info("DBG", "p_sequencer handle is valid.", UVM_LOW)

    if (p_sequencer.hbus_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.hbus_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.hbus_seqr handle is valid.", UVM_LOW)
      
    if (p_sequencer.yapp_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.yapp_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.yapp_seqr handle is valid.", UVM_LOW)
 repeat(6)
    begin
    `uvm_info("DBG", "Setting the Router ", UVM_LOW)
    config_seq = hbus_set_yapp_regs_seq::type_id::create("config_seq");
    
    if (config_seq == null) `uvm_fatal("DBG", "Config_seq failed to create!")

    `uvm_info("DBG", "Calling start on Config_seq...", UVM_LOW)
  // Set the desired values BEFORE starting the sequence
config_seq.starting_phase = this.starting_phase;
              if (!config_seq.randomize() with { max_pkt_reg inside {[10:30]}; enable_reg == 1; })
            `uvm_fatal("VSEQ", "Config randomization failed")                 //config_seq.enable_reg  = 1;  // Enable the router
                 config_seq.start(p_sequencer.hbus_seqr, this); 
`uvm_info("DBG", "config_seq finished successfully.", UVM_LOW)
// In your virtual_sequences
    uvm_config_db#(int)::set(null, "*", "MAX_PKT_REG", config_seq.max_pkt_reg);   
    `uvm_info("STATUS",$sformatf("Configured The Router with  MAX_PKT_LEN= %0d , ENABLE= %0d",config_seq.max_pkt_reg,config_seq.enable_reg),UVM_LOW)

    //----------------------------------------------------------
    //Starting to the packets with GOOD,BAD PARITY
    //----------------------------------------------------------
repeat(1) begin
    // Runs 'yapp_seq' specifically on the 'p_sequencer.yapp_seqr' handle
    `uvm_info(get_type_name(),"Calling the yapp_with_packet_size_seq from virtual_sequences",UVM_LOW)
    `uvm_do_on(yapp_seq, p_sequencer.yapp_seqr)
end
end
    // --- DEBUG: Check starting_phase before dropping objection ---
    if (starting_phase != null) begin
      `uvm_info("DBG", "Dropping objection...", UVM_LOW)
      starting_phase.drop_objection(this, get_type_name());
    end

endtask
endclass

class coverage_seq extends uvm_sequence;
	`uvm_object_utils(coverage_seq)
	function new(string name="coverage_seq");
		super.new(name);
	endfunction
	yapp_packet pkt;
	yapp_012_seq yapp_seq; //consecutive packets with addresses 0-1-2
	 hbus_set_yapp_regs_seq config_seq;
	hbus_read_seq read_seq; //reading the maxpktsize register 
	hbus_write_seq write_other_seq;
 	`uvm_declare_p_sequencer(router_virtual_sequencer)
	
task body();
	`uvm_info(get_type_name(),"Entered in coverage_seq",UVM_LOW)
	
    // --- DEBUG: Check starting_phase before raising objection ---
    if (starting_phase == null) begin
      `uvm_info("DBG", "starting_phase is null! Objection will NOT be raised.", UVM_LOW)
    end else begin
      `uvm_info("DBG", "starting_phase is valid. Raising objection.", UVM_LOW)
      starting_phase.raise_objection(this, get_type_name());
    end

    // --- DEBUG: Verify all sequencer handles from p_sequencer ---
    if (p_sequencer == null)
      `uvm_fatal("DBG", "p_sequencer is completely null! Check your virtual sequencer assignment.")
    else
      `uvm_info("DBG", "p_sequencer handle is valid.", UVM_LOW)

    if (p_sequencer.hbus_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.hbus_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.hbus_seqr handle is valid.", UVM_LOW)
      
    if (p_sequencer.yapp_seqr == null)
      `uvm_fatal("DBG", "p_sequencer.yapp_seqr is null! Check connect_phase in env.")
    else
      `uvm_info("DBG", "p_sequencer.yapp_seqr handle is valid.", UVM_LOW)

    //--------------------------------------------------
    // Setting up the router 
    //--------------------------------------------------
      `uvm_info("DBG", "Setting the Router ", UVM_LOW)
    config_seq = hbus_set_yapp_regs_seq::type_id::create("config_seq");
    
    if (config_seq == null) `uvm_fatal("DBG", "Config_seq failed to create!")

    `uvm_info("DBG", "Calling start on Config_seq...", UVM_LOW)
  // Set the desired values BEFORE starting the sequence
config_seq.starting_phase = this.starting_phase;
              if (!config_seq.randomize() with { max_pkt_reg==63; enable_reg==1; })
            `uvm_fatal("VSEQ", "Config randomization failed")                 //config_seq.enable_reg  = 1;  // Enable the router
                 config_seq.start(p_sequencer.hbus_seqr, this); 
`uvm_info("DBG", "config_seq finished successfully.", UVM_LOW)
// In your virtual_sequences
    uvm_config_db#(int)::set(null, "*", "MAX_PKT_REG", config_seq.max_pkt_reg);   
    `uvm_info("STATUS",$sformatf("Configured The Router with  MAX_PKT_LEN= %0d , ENABLE= %0d",config_seq.max_pkt_reg,config_seq.enable_reg),UVM_LOW)

    `uvm_do_on(read_seq, p_sequencer.hbus_seqr)
    `uvm_do_on_with(read_seq, p_sequencer.hbus_seqr,{read_seq.address==1;})
    `uvm_do_on_with(read_seq, p_sequencer.hbus_seqr,{read_seq.address==4;})
    `uvm_do_on_with(write_other_seq,p_sequencer.hbus_seqr,{write_other_seq.address==2; write_other_seq.data==34;})
    //----------------------------------------------------------
    //Starting to the packets with GOOD,BAD PARITY
    //----------------------------------------------------------

    // Runs 'yapp_seq' specifically on the 'p_sequencer.yapp_seqr' handle
    `uvm_do_on(yapp_seq, p_sequencer.yapp_seqr)
    `uvm_info(get_type_name(),"Calling the yapp_with_bad_size_seq from virtual_sequences",UVM_LOW)
    `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==1;pkt.parity_type==GOOD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==1;pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==8;pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==53;pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==20;})
    `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==0; pkt.length==63;pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==1; pkt.length==1; pkt.parity_type==GOOD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==1; pkt.length==1;pkt.parity_type==BAD_PARITY;})
   `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==1; pkt.length==63; pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==1; pkt.length==8;pkt.parity_type==BAD_PARITY;})
    //`uvm_do_on_with(pkt,p_sequencer.yapp_seqr,pkt.length,{addr=0; length==1;})
    //`uvm_do_on_with(pkt,p_sequencer.yapp_seqr,pkt.length,{addr=0; length==1;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==2; pkt.length==1; pkt.parity_type==GOOD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==2; pkt.length==1;pkt.parity_type==BAD_PARITY;})
  `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==2; pkt.length==8;pkt.parity_type==BAD_PARITY;})
    `uvm_do_on_with(pkt,p_sequencer.yapp_seqr,{pkt.addr==2; pkt.length==63;pkt.parity_type==BAD_PARITY;})




    // --- DEBUG: Check starting_phase before dropping objection ---
    if (starting_phase != null) begin
      `uvm_info("DBG", "Dropping objection...", UVM_LOW)
      starting_phase.drop_objection(this, get_type_name());
    end

endtask

endclass
