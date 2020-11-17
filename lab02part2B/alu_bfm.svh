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

task automatic input_deserializer(output bit[98:0] data_read_input);
	bit [8:0] read_iterator_input;
	read_iterator_input = 99;
	@(negedge sin);
	repeat(99)
		begin
			@(posedge clk);
			read_iterator_input--;
			data_read_input[read_iterator_input] = sin;
		end	
endtask


endinterface	