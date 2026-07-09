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

