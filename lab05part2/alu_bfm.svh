interface alu_bfm;
	import alu_pkg::*;
	logic clk,rst_n,sin,sout;

   bit[54:0] read_data_output; 
   bit signed[31:0] read_number_output;
   bit[4:0] read_flags; 
   bit[2:0] read_crc_output; 
   bit[2:0] read_err_flags;
   bit read_parity_bit;
   
	
   bit [98:0] data_to_send;
   bit reset_now;

	
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

initial
	begin
	forever
		begin
			@(negedge rst_n)
			reset_now = 1;
		end
end		

initial
	begin
	forever
		begin
			input_deserializer(data_to_send);
        	command_monitor_h.write_to_monitor(data_to_send, reset_now);
			reset_now = 0;
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
	forever
		begin
			output_deserializer(read_data_output,read_number_output, read_flags, read_crc_output, read_err_flags, read_parity_bit);
			result_monitor_h.write_to_monitor(read_data_output,read_number_output, read_flags, read_crc_output, read_err_flags, read_parity_bit);
		end
	end
	


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function bit [43:0] DATA(int data);
	bit [43:0] data_ret;
	data_ret = {2'b00,data[31:24],1'b1,2'b00,data[23:16],1'b1,2'b00,data[15:8],1'b1,2'b00,data[7:0],1'b1};
	return data_ret;
endfunction	
	
function bit [10:0] CTL(byte data);
	bit [10:0] ctl_ret;
	ctl_ret = {2'b01,data,1'b1};
	return ctl_ret;
endfunction	




	
task send_op(input bit signed[31:0] A, input bit signed[31:0] B, input operation_t op_code, input function_t gen_function);
	begin
		bit[98:0] data_to_send;
		bit[3:0] CRC_input;
		bit[7:0] loop_iterations_data;
				case(gen_function)
					GEN_NORMAL_OPERATION:
						begin
							CRC_input = calc_CRC_input(B, A, op_code);
							data_to_send = {DATA(B),DATA(A),CTL({1'b0,op_code,CRC_input})};
						end
					GEN_CRC_ERROR:
						begin
							CRC_input = calc_CRC_input(B, A, op_code)+1;
							data_to_send = {DATA(B),DATA(A),CTL({1'b0,op_code,CRC_input})};
						end
					GEN_BYTE_ERROR:
						begin
							CRC_input = calc_CRC_input(B, A, op_code);
							data_to_send = {DATA(B),DATA(A),CTL({1'b0,op_code,CRC_input})};
							data_to_send = {{11{1'b1}},data_to_send[87:0]};
						end
					GEN_RESET:
						begin
							rst_n = 1;
							#320;
							rst_n = 0;
							#20;
							rst_n = 1;
							#200;	
						end	
					GEN_UNKNOWN_OP:
						begin
							op_code = no_op;
							CRC_input = calc_CRC_input(B, A, op_code);
							data_to_send = {DATA(B),DATA(A),CTL({1'b0,op_code,CRC_input})};
						end
				endcase
				if(gen_function != GEN_RESET)
					begin
						loop_iterations_data = 99;
						repeat(99)
							begin
								@(negedge clk);
								loop_iterations_data--;
								sin = data_to_send[loop_iterations_data];
							end
						sin = 1;
					end
			end
endtask




endinterface	