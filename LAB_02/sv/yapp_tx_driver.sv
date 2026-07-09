class yapp_tx_driver extends uvm_driver #(yapp_packet);
  `uvm_component_utils(yapp_tx_driver);
  yapp_packet pckt;
  function new(string name = "yapp_tx_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(pckt);
      send_to_dut(pckt);
      seq_item_port.item_done();
    end
  endtask
  task send_to_dut(yapp_packet pckt);
    `uvm_info("Driver Class", $sformatf("Packet is %s \n", pckt.sprint()), UVM_LOW)
  endtask
endclass
