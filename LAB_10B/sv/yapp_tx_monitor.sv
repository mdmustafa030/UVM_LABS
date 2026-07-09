class yapp_tx_monitor extends uvm_monitor;
	`uvm_component_utils(yapp_tx_monitor)
	virtual interface yapp_if vif;
int num_pkt_col;
yapp_packet packet_collected;
uvm_analysis_port #(yapp_packet) item_collected_port;
//coverpoint for packet length , with name bins
/*1. What is "functional coverage," really?
Imagine you're a teacher and 30 kids each roll a die during class. You want to know: did every number 1–6 come up at least once? You could watch every roll and tick a box on a chart each time a number appears. At the end, you look at the chart — if "6" was never ticked, you know you need more rolls.
That chart is functional coverage. In verification:

The "die roll" = a packet your testbench sends to the DUT.
The "chart" = a covergroup.
Each "page" of the chart tracking one thing (like "which number came up") = a coverpoint.
Each box on that page (like "box for 1", "box for 2"...) = a bin.

So functional coverage doesn't check if your design works — that's what checkers/scoreboards do. It only tells you "did my test actually try everything I care about?"

2. The building blocks
TermKid analogySystemVerilogcovergroupThe whole checklist notebookcovergroup cg; ... endgroupcoverpointOne page tracking one variablecoverpoint pkt.length;binOne checkbox on that pagebins MIN = {1};crossA page that only ticks when two things happen together (e.g. "rolled a 6 AND it was raining")cross cp1, cp2;sample()"Take a photo right now and tick whatever boxes apply"cg.sample();
The most important habit to build: a covergroup only ticks boxes when you call .sample(). It doesn't watch continuously — it's a camera, not a video recorder. You decide the exact moment to click the shutter.

3. Where does this live in UVM? (and why the monitor)
Think of your monitor as a security camera at a checkpoint. It already watches every packet go by (that's its whole job — passively observing the DUT interface). It doesn't drive anything; it just sees things.
Since the monitor already has its hands on every completed packet (in your collect_packets() method), it's the natural place to also click the coverage "camera" — the instant a packet is fully captured, you sample it. That's why the lab tells you to put the covergroup in yapp_tx_monitor.sv, not in the driver or sequencer.*/
covergroup cg_yapp_pkt;
	cp_length: coverpoint packet_collected.length{
	bins MIN ={1};
	bins BABY ={[2:10]};
	bins TEENY ={[11:40]};
	bins GROWNUP={[41:62]};
	bins MAX={63};
	}

	cp_addr: coverpoint packet_collected.addr{
		bins ADDR0={0};
		bins ADDR1={1};
		bins ADDR2={2};
	        illegal_bins INVALID_ADDR={3};
		}

	cp_parity: coverpoint packet_collected.parity_type{
			bins GOOD={0};
			bins BAD={1};
			}
	crx_packet: cross cp_addr,cp_length,cp_parity {
		//ignore_bins skip_illegal = binsof(cp_addr.INVALID_ADDR);
		}
endgroup
	function new(string name="yapp_monitor",uvm_component parent=null);
		super.new(name,parent);
		item_collected_port = new("item_collected_port",this);
		cg_yapp_pkt=new();
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info("mon","start of simulation phase of monitor",UVM_HIGH)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!yapp_vif_config::get(this,"","vif", vif))
                   `uvm_fatal("NOVIF",{"vif not set for: ",get_full_name(),".vif"})		
	endfunction
	task run_phase(uvm_phase phase);
		`uvm_info("Monitor","I am in run_phase of Monitor",UVM_LOW)
		forever begin
		collect_packet();
		         end
	endtask

	  // Collect Packets
  task collect_packet();
      //Monitor looks at the bus on posedge (Driver uses negedge)
      //
      packet_collected =yapp_packet::type_id::create("packet_collected");
      @(posedge vif.in_data_vld);

      @(posedge vif.clock iff (!vif.in_suspend))

      // Begin transaction recording
      void'(this.begin_tr(packet_collected, "Monitor_YAPP_Packet"));

      `uvm_info(get_type_name(), "Collecting a packet", UVM_HIGH)
      // Collect Header {Length, Addr}
      { packet_collected.length, packet_collected.addr }  = vif.in_data;
      packet_collected.payload = new[packet_collected.length]; // Allocate the payload
      // Collect the Payload
      for (int i=0; i< packet_collected.length; i++) begin
         @(posedge vif.clock iff (!vif.in_suspend))
         packet_collected.payload[i] = vif.in_data;
      end

      // Collect Parity and Compute Parity Type
       @(posedge vif.clock iff (!vif.in_suspend))
         packet_collected.parity = vif.in_data;
       packet_collected.parity_type = (packet_collected.parity == packet_collected.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      this.end_tr(packet_collected);
      	item_collected_port.write(packet_collected);

      cg_yapp_pkt.sample();
`uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", packet_collected.sprint()), UVM_LOW)
      num_pkt_col++;
  endtask : collect_packet

  function void report_phase(uvm_phase phase);
   `uvm_info(get_type_name(),$sformatf("Collected %0d packets",num_pkt_col),UVM_LOW);
endfunction

endclass
