class yapp_tx_driver extends uvm_driver #(yapp_packet);
	`uvm_component_utils(yapp_tx_driver);
	yapp_packet pckt;
	virtual interface yapp_if vif;
        int num_sent;
	function new(string name="yapp_tx_driver", uvm_component parent=null);
	super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
			if (!yapp_vif_config::get(this,"","vif", vif))
                   `uvm_fatal("NOVIF",{"vif not set for: ",get_full_name(),".vif"})	
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
	      super.start_of_simulation_phase(phase);
	      `uvm_info("drv","start of simulation phase of driver",UVM_HIGH)
	endfunction
	/*task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
		begin
			seq_item_port.get_next_item(pckt);
			send_to_dut(pckt);
			seq_item_port.item_done();
		end
	endtask
	task send_to_dut(yapp_packet pckt);
		`uvm_info("Driver Class",$sformatf("Packet is %s \n", pckt.sprint()),UVM_LOW)
	endtask */

  // Replace your run_phase() method with this:
  task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

task get_and_drive();

  @(negedge vif.reset);
  `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)

  forever begin
 `uvm_info("DRV","Waiting for item",UVM_LOW)
    // 1. Get transaction from sequencer
    seq_item_port.get_next_item(pckt);
 `uvm_info("DRV","Got item",UVM_LOW)
    // 2. Drive transaction to DUT
    send_to_dut(pckt);

    // 3. Inform sequencer transaction is completed
    seq_item_port.item_done();

  end

endtask : get_and_drive

  // Reset all TX signals
  task reset_signals();
    forever begin
      @(posedge vif.reset);
       `uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM)
      vif.in_data           <=  'hz;
      vif.in_data_vld       <= 1'b0;
      disable send_to_dut;
    end
  endtask : reset_signals

   // Gets a packet and drive it into the DUT
  task send_to_dut(yapp_packet packet);

    // Wait for packet delay
    repeat(packet.packet_delay)
      @(negedge vif.clock);

    // Start to send packet if not in_suspend signal
      @(negedge vif.clock iff (!vif.in_suspend));

    // Begin Transaction recording
    void'(this.begin_tr(packet, "Input_YAPP_Packet"));

    // Enable start packet signal
    vif.in_data_vld <= 1'b1;

    // Drive the Header {Length, Addr}
    vif.in_data <= { packet.length, packet.addr };

    // Drive Payload
    for (int i=0; i<packet.payload.size(); i++) begin
      @(negedge vif.clock iff (!vif.in_suspend))
      vif.in_data <= packet.payload[i];
    end
    // Drive Parity and reset Valid
    @(negedge vif.clock iff (!vif.in_suspend))
    vif.in_data_vld <= 1'b0;
    vif.in_data  <= packet.parity;

        num_sent++;
   // End transaction recording
    this.end_tr(packet);
	`uvm_info(get_type_name(), $sformatf("Packet Sent  :\n%s", packet.sprint()), UVM_LOW)
	@(negedge  vif.clock)
      vif.in_data  <= 8'bz;

  endtask : send_to_dut

  // UVM report_phase() 
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction : report_phase
	
endclass
