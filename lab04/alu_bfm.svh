interface alu_bfm;
	import alu_pkg::*;
	logic clk,rst_n,sin,sout;
	
	
	initial begin : clk_gen
		  #10
	      clk = 0;
	      forever begin : clk_frv
	         #10;
	         clk = ~clk;
	      end
	   end	

//////////////////////////////////////////////////////////////////////////////////
task init_alu();
	sin = 1;
	rst_n = 1;
	#320;
	rst_n = 0;
	#20;
	rst_n = 1;
	#200;
endtask

task reset_alu();
	rst_n = 1;
	#320;
	rst_n = 0;
	#20;
	rst_n = 1;
	#200;
endtask

task automatic send_data(input bit[98:0] data_to_send);
	bit[7:0] loop_iterations_data;
	loop_iterations_data = 99;
	repeat(99)
		begin
			@(negedge clk);
			loop_iterations_data--;
			sin = data_to_send[loop_iterations_data];
		end
	sin = 1;
endtask

///////////////////////////////////////////////////////////////////////////////////////////////////////

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

command_monitor command_monitor_h;


	command_s command;

initial
	begin
	forever
		begin
			@(negedge rst_n)
			command.reset_now = 1;
		end
end		

initial
	begin
	forever
		begin
			input_deserializer(command.data_to_send);
        	command_monitor_h.write_to_monitor(command);
			command.reset_now = 0;
		end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////

task output_deserializer(output bit[54:0] read_data_output,	output bit signed[31:0] read_number_output, output bit[4:0] read_flags, output bit[2:0] read_crc_output, output bit[2:0] read_err_flags, output bit read_parity_bit);
		begin
			state_deserializer_t state_deserializer;	
			bit[7:0] read_iterator_output;
			bit dummy;
			state_deserializer = WAIT_FOR_OUTPUT;
			forever
				begin			
					case(state_deserializer)	
	 					WAIT_FOR_OUTPUT:
							begin
								read_iterator_output = 54;
								@(negedge sout);
								@(posedge clk);
								read_data_output[read_iterator_output] = sout;
								read_iterator_output--;
								@(posedge clk);
								read_data_output[read_iterator_output] = sout;
								read_iterator_output--;
								if(read_data_output[read_iterator_output+1] == 1)
									state_deserializer = READ_OUTPUT_CLT;
								else
									state_deserializer = READ_OUTPUT_DATA;
							end	
						READ_OUTPUT_DATA:
							begin
								repeat(53)
									begin
										@(posedge clk);
										read_data_output[read_iterator_output] = sout;
										read_iterator_output--;
									end
								read_number_output = {read_data_output[52:45],read_data_output[41:34],read_data_output[30:23],read_data_output[19:12]};
								read_flags = read_data_output[7:4];
								read_crc_output = read_data_output[3:1];
								state_deserializer = DONE;
							end	
						READ_OUTPUT_CLT:	
							begin
								repeat(9)
									begin
										@(posedge clk);
										read_data_output[read_iterator_output] = sout;
										read_iterator_output--;
									end	
								read_err_flags = read_data_output[48:46];
								read_parity_bit = read_data_output[45];
								state_deserializer = DONE;	
							end
						DONE:
							begin
								state_deserializer = WAIT_FOR_OUTPUT;
								break;
							end
					endcase
				end	
 end
endtask

result_monitor result_monitor_h;

initial
	begin
	result_s result;
	forever
		begin
			//$display("deserializer starts");
			output_deserializer(result.read_data_output,result.read_number_output, result.read_flags, result.read_crc_output, result.read_err_flags, result.read_parity_bit);
			result_monitor_h.write_to_monitor(result);
		end
	end
	

endinterface	