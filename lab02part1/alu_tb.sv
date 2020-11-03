`timescale 1ns/1ps
module top_TB;

alu_bfm bfm();	

	
mtm_Alu DUT (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));	
tester tester(.bfm_tester(bfm));
coverage coverage(.bfm_cov(bfm));
scoreboard scoreboard(.sb_bfm(bfm));	


endmodule	