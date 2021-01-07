`timescale 1ns/1ps
module top_TB;
	
import uvm_pkg::*;
`include "uvm_macros.svh"		
import alu_pkg::*;
	
alu_bfm bfm();		
mtm_Alu dut (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));	


initial begin 
	uvm_config_db #(virtual alu_bfm)::set(null, "*", "bfm", bfm);
	run_test();
end

endmodule	