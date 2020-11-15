`timescale 1ns/1ps
module top_TB;
import alu_pkg::*;
testbench testbench_h;
alu_bfm bfm();	
mtm_Alu DUT (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));	
	
initial begin 
	testbench_h = new(bfm);
	testbench_h.execute();
end

endmodule	