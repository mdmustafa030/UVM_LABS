
`ifndef YAPP_5_PACKETS
`define YAPP_5_PACKETS
  class yapp_5_packets extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_5_packets)

  function new(string name = "yapp_5_packets");
    super.new(name);
  endfunction


  task body();
repeat (5) begin
      yapp_packet pkt;
      `uvm_info(get_type_name(),"Base pcaket classs",UVM_LOW)
      pkt = yapp_packet::type_id::create("pkt");
      `uvm_do(pkt)
    end
  endtask

endclass
`endif

class yapp_012_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_012_seq)
	task body();
		yapp_packet pkt;
		`uvm_info(get_type_name(),"yapp_012_seq",UVM_LOW)
		pkt = yapp_packet::type_id::create("pkt");
		`uvm_do_with(pkt,{addr_i==0;})
		`uvm_do_with(pkt,{addr_i==1;})
		`uvm_do_with(pkt,{addr_i==2;})
	endtask
endclass


class yapp_1_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_1_seq)
	task body();
		yapp_packet pkt;
		`uvm_info(get_type_name(),"yapp_1_seq",UVM_LOW)
		pkt=yapp_packet::type_id::create("pkt");
		`uvm_do_with(pkt,{addr_i==1;})
	endtask
endclass


class yapp_111_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_111_seq)
	task body();
		yapp_1_seq pkt;
		`uvm_info(get_type_name(),"yapp_111_seq",UVM_LOW);
		repeat(3)
		begin
		pkt=yapp_1_seq::type_id::create("pkt");
			`uvm_do(pkt)
		end
	endtask
endclass


class yapp_repeat_addr_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_repeat_addr_seq)
	task body();
	yapp_packet pkt;
	`uvm_info(get_type_name(),"yapp_repeat_addr_seq",UVM_LOW)
	pkt=yapp_packet::type_id::create("pkt");
	`uvm_do(pkt)
//	bit[1:0] addr = pkt.addr_i;
	repeat(1)
	begin
		pkt=yapp_packet::type_id::create("pkt");
		`uvm_do_with(pkt,{addr_i==addr_i;})
	end
endtask
endclass


class yapp_incr_payload_seq extends yapp_5_packets;
	int i;
	`uvm_object_utils(yapp_incr_payload_seq)
	task body();
	yapp_packet pkt;
	`uvm_info(get_type_name(),"entered yapp_incr_payload_seq",UVM_LOW)
	`uvm_create(pkt)
//	assert(pkt.randomize());	
   if(!pkt.randomize())
      `uvm_fatal("RANDFAIL","Randomization failed")

	for(i=0;i<pkt.length_i;i++)
	pkt.payload[i]=i;
		pkt.parity=pkt.cal_parity();
		
   `uvm_info("SEQ","Before send",UVM_LOW)
   `uvm_send(pkt)
   `uvm_info("SEQ","After send",UVM_LOW)
	endtask
endclass
