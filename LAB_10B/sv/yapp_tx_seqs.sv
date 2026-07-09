
`ifndef YAPP_5_PACKETS
`define YAPP_5_PACKETS
  class yapp_5_packets extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_5_packets)

  function new(string name = "yapp_5_packets");
    super.new(name);
    //set_automatic_phase_objection(1);
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
		`uvm_do_with(pkt,{addr==0;})
		`uvm_do_with(pkt,{addr==1;})
		`uvm_do_with(pkt,{addr==2;})
	endtask
endclass


class yapp_1_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_1_seq)
	task body();
		yapp_packet pkt;
		`uvm_info(get_type_name(),"yapp_1_seq",UVM_LOW)
		pkt=yapp_packet::type_id::create("pkt");
		`uvm_do_with(pkt,{addr==1;})
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
		`uvm_do_with(pkt,{addr==addr;})
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

	for(i=0;i<pkt.length;i++)
	pkt.payload[i]=i;
		pkt.parity=pkt.calc_parity();
		
   `uvm_info("SEQ","Before send",UVM_LOW)
   `uvm_send(pkt)
   `uvm_info("SEQ","After send",UVM_LOW)
	endtask
endclass

class yapp_with_bad_size_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_with_bad_size_seq)
		int max_pkt_reg=63;
	function new(string name="yapp_with_bad_size_seq");
		super.new(name);
	endfunction
	task body();
	
		yapp_packet pkt;
		`uvm_info(get_type_name(),"Entered yapp_with_bad_size",UVM_LOW)

		// Retrieve from config_db
        if (!uvm_config_db#(int)::get(null, get_full_name(), "MAX_PKT_REG", max_pkt_reg)) begin
            `uvm_fatal("YAPP_SEQ", "Failed to get MAX_PKT_REG from config_db!")
        end

        `uvm_info(get_type_name(), $sformatf("Max Pkt Size(Recieved) is %0d", max_pkt_reg), UVM_LOW)
		pkt=yapp_packet::type_id::create("pkt");
	`uvm_do_with(pkt,{length > max_pkt_reg;})
	endtask
endclass

class yapp_with_packet_size_seq extends yapp_5_packets;
	`uvm_object_utils(yapp_with_packet_size_seq)
	int max_pkt_size=63;
	function new(string name="yapp_with_packet_size_seq");
		super.new(name);
	endfunction
task body();
	 yapp_packet pkt;
	    int category;
	 pkt = yapp_packet::type_id::create("pkt");
 
	`uvm_info(get_type_name(),"entered the yapp_with_packet_size_seq body",UVM_LOW)
   
      assert(std::randomize(category) with {
         category dist { 0 := 20, 1 := 30, 2 := 30, 3 := 20 };
      });
      case(category)
         0: `uvm_do_with(pkt, { length < (max_pkt_size - 2); })
         1: `uvm_do_with(pkt, { length == (max_pkt_size - 1); })
         2: `uvm_do_with(pkt, { length ==  max_pkt_size;     })
         3: `uvm_do_with(pkt, { length >   max_pkt_size;     })
      endcase
      `uvm_info(get_type_name(),
         $sformatf("category=%0d max_pkt_size=%0d generated length=%0d",
                   category, max_pkt_size, pkt.length),
         UVM_MEDIUM)
   endtask
endclass
