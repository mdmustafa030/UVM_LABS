typedef enum{
	GOOD_PARITY,
	BAD_PARITY
	}parity_t;

class yapp_packet extends uvm_sequence_item;
	//`uvm_objects_utils(yapp_packet) // registering to the factory
	rand bit [1:0] addr_i;
	rand bit [5:0] length_i;
	rand byte payload[];
        byte parity; 
	rand parity_t parity_type;
	rand int packet_delay;
	
	// registering each variable to the field macros such that to get
	// access to the all functions of the field macros.
	`uvm_object_utils_begin(yapp_packet)
	`uvm_field_int(addr_i, UVM_DEFAULT)
	`uvm_field_int(length_i, UVM_DEFAULT)
	`uvm_field_array_int(payload, UVM_DEFAULT)
	`uvm_field_int(parity, UVM_DEFAULT)
	`uvm_field_enum(parity_t,parity_type, UVM_DEFAULT)
	`uvm_field_int(packet_delay, UVM_DEFAULT)
	`uvm_object_utils_end

	function byte cal_parity();
               byte m={length_i,addr_i}; // storing header first
	       foreach(payload[i])
		       m^=payload[i]; // calculating parity using header to all the payloads
	       return m;
	endfunction
	
	function new(string name="yapp_packet");// constructor call
		super.new(name);
	endfunction

	function void post_randomize();
		if(parity_type == GOOD_PARITY)
			parity=cal_parity();
		else
			parity=cal_parity()^8'hAA;
	endfunction
   
	constraint c1{addr_i inside {[0:2]};}
	constraint c2{length_i inside {[1:63]};}
	constraint c3{payload.size()==length_i;}
	constraint c4{parity_type dist{GOOD_PARITY:=5, BAD_PARITY:=1};}
	constraint c5{packet_delay inside{[0:20]};}
endclass
