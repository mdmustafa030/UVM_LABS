import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../sv/yapp_packet.sv"
module top;
yapp_packet y1;

initial
begin

		y1=yapp_packet::type_id::create("y1");
	repeat(10)
	begin
		y1.randomize();
		y1.print();
		y1.print(uvm_default_tree_printer);
	end
end
endmodule
