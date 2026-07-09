class yapp_tx_monitor extends uvm_monitor;
  `uvm_component_utils(yapp_tx_monitor)
  virtual interface yapp_if vif;
  int num_pkt_col;
  yapp_packet packet_collected;
  function new(string name = "yapp_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("mon", "start of simulation phase of monitor", UVM_HIGH)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"vif not set for: ", get_full_name(), ".vif"})
  endfunction
  task run_phase(uvm_phase phase);
    `uvm_info("Monitor", "I am in Monitor", UVM_LOW)
    forever begin
      collect_packet();
    end
  endtask

  // Collect Packets
  task collect_packet();
    //Monitor looks at the bus on posedge (Driver uses negedge)
    //
    packet_collected = yapp_packet::type_id::create("packet_collected");
    @(posedge vif.in_data_vld);

    @(posedge vif.clock iff (!vif.in_suspend))

      // Begin transaction recording
      void'(this.begin_tr(
          packet_collected, "Monitor_YAPP_Packet"
      ));

    `uvm_info(get_type_name(), "Collecting a packet", UVM_HIGH)
    // Collect Header {Length, Addr}
    {packet_collected.length_i, packet_collected.addr_i} = vif.in_data;
    packet_collected.payload = new[packet_collected.length_i];  // Allocate the payload
    // Collect the Payload
    for (int i = 0; i < packet_collected.length_i; i++) begin
      @(posedge vif.clock iff (!vif.in_suspend)) packet_collected.payload[i] = vif.in_data;
    end

    // Collect Parity and Compute Parity Type
    @(posedge vif.clock iff (!vif.in_suspend)) packet_collected.parity = vif.in_data;
    packet_collected.parity_type = (packet_collected.parity == packet_collected.cal_parity()) ? GOOD_PARITY : BAD_PARITY;
    // End transaction recording
    this.end_tr(packet_collected);
    `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", packet_collected.sprint()),
              UVM_LOW)
    num_pkt_col++;
  endtask : collect_packet

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Collected %0d packets", num_pkt_col), UVM_LOW);
  endfunction

endclass
