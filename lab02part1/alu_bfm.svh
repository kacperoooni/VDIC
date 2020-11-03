interface alu_bfm;
	logic clk,rst_n,sin,sout;
	
	
	initial begin : clk_gen
		  #10
	      clk = 0;
	      forever begin : clk_frv
	         #10;
	         clk = ~clk;
	      end
	   end	
	
endinterface	