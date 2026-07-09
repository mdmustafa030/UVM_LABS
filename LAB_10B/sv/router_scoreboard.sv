
`uvm_analysis_imp_decl(_yapp)
`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)
class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard)
	uvm_analysis_imp_yapp#(yapp_packet,router_scoreboard) yapp_imp;
	uvm_analysis_imp_chan0#(yapp_packet,router_scoreboard) chan0_imp;
	uvm_analysis_imp_chan1#(yapp_packet,router_scoreboard) chan1_imp;
	uvm_analysis_imp_chan2#(yapp_packet,router_scoreboard) chan2_imp;
	int packets_recieved;
	int wrong_packets;
	int matched_packets;
	int max_pkt_size=63;
	yapp_packet pkt_qu[3][$];
	function new(string name="router_scoreboard",uvm_component parent=null);
		super.new(name,parent);
		yapp_imp =new("yapp_imp",this);
		chan0_imp = new("chan0_imp",this);
		chan1_imp = new("chan1_imp",this);
		chan2_imp = new("chan2_imp",this);
	endfunction
	virtual function void write_yapp(yapp_packet pkt);
    yapp_packet cloned_pkt;
        if (!uvm_config_db#(int)::get(null, get_full_name(), "MAX_PKT_REG", max_pkt_size)) begin
            `uvm_fatal("YAPP_SEQ", "Failed to get MAX_PKT_REG from config_db!")
        end
        if(pkt.addr==3 || pkt.length<=0 || pkt.length>max_pkt_size)
	    return;
    else begin
    $cast(cloned_pkt,pkt.clone());
    pkt_qu[cloned_pkt.addr].push_back(cloned_pkt);
    end
  endfunction
  	virtual function void write_chan0(yapp_packet pkt);
    yapp_packet cloned_pkt;
    packets_recieved++;
    cloned_pkt=pkt_qu[0].pop_front();
    if(pkt.compare(cloned_pkt))
    begin
	    matched_packets++;
  `uvm_info(get_type_name(),"Packet Matched at Channel-0",UVM_LOW);
  end
  else begin
	    wrong_packets++;
  `uvm_info(get_type_name(),"Packets Mismatched at Chaneel-0",UVM_LOW);
    end
  endfunction

    	virtual function void write_chan1(yapp_packet pkt);
    yapp_packet cloned_pkt;
    packets_recieved++;
    cloned_pkt=pkt_qu[1].pop_front();
    if(pkt.compare(cloned_pkt))
    begin
	    matched_packets++;
  `uvm_info(get_type_name(),"Packet Matched at Channel-1",UVM_LOW);
  end
  else begin
	    wrong_packets++;
  `uvm_info(get_type_name(),"Packets Mismatched at Chaneel-1",UVM_LOW);
    end
  endfunction

    	virtual function void write_chan2(yapp_packet pkt);
    yapp_packet cloned_pkt;
    packets_recieved++;
    cloned_pkt=pkt_qu[2].pop_front();
    if(pkt.compare(cloned_pkt))
    begin
	    matched_packets++;
  `uvm_info(get_type_name(),"Packet Matched at Channel-2",UVM_LOW);
  end
  else begin
	    wrong_packets++;
  `uvm_info(get_type_name(),"Packets Mismatched at Channel-2",UVM_LOW);
    end
  endfunction
	function void report_phase(uvm_phase phase);
		`uvm_info("DBG","entered the REPORT_PHASE",UVM_LOW)
		super.report_phase(phase);
  `uvm_info(get_type_name(),$sformatf("Packets recieved %0d packets",packets_recieved),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("Packets Not Matched %0d packets",wrong_packets),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("Packets Matched %0d packets",matched_packets),UVM_LOW);

	endfunction
endclass
