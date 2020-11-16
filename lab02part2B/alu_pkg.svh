

package alu_pkg;
	typedef enum bit[2:0] {WAIT_FOR_OUTPUT = 3'b101,
	                       READ_OUTPUT_DATA = 3'b111,
	                       READ_OUTPUT_CLT = 3'b110,
	                       READ_INPUT = 3'b100,
	                       DONE = 3'b010} state_deserializer_t;	
		
		
		
	typedef enum bit[3:0] {GEN_NORMAL_OPERATION  = 1,
	                       GEN_CRC_ERROR = 2, 
	                       GEN_BYTE_ERROR = 3,
	                       GEN_RESET = 4,
	                       GEN_UNKNOWN_OP = 5} function_t;
	
	typedef enum bit[2:0] {and_op  = 3'b000,
	                       or_op = 3'b001, 
	                       add_op = 3'b100,
	                       sub_op = 3'b101,
	                       no_op = 3'b111} operation_t;
		
	typedef enum bit[2:0] {INIT  = 3'b000,
	                       RESET = 3'b001, 
	                       SEND = 3'b100,
	                       DONE_SENDING = 3'b010,
	                       GENERATE_FUNCTION = 3'b011} state_tester_t;
	
	
	task check_err_flags(
		input [98:0] data_read_input,
		output [2:0] predicted_err_flags
		);	
		bit signed[31:0] A_read,B_read;
		bit dummy;//carry bit
		bit[3:0] predicted_CRC_input,read_crc_input;
		operation_t read_op_code;
		predicted_err_flags = 0;
		{B_read,A_read,dummy,read_op_code,read_crc_input} = {data_read_input[96:89],data_read_input[85:78],data_read_input[74:67],data_read_input[63:56],data_read_input[52:45],data_read_input[41:34],data_read_input[30:23],data_read_input[19:12],data_read_input[8:1]};
		if((data_read_input[10] == 0 ) & (data_read_input[9] == 1)) // OK NUMBER
			   begin
			   		predicted_CRC_input = calc_CRC_input(B_read, A_read, read_op_code);
				   	if(read_crc_input != predicted_CRC_input) predicted_err_flags[1] = 1; //WRONG INPU CRC CODE
				   	else if((read_op_code != add_op)&(read_op_code != and_op)&(read_op_code != or_op)&(read_op_code != sub_op)) predicted_err_flags[0] = 1; //WRONG OP CODE
			   end
		   else
		   	 predicted_err_flags[2] = 1; //WRONG NUMBER
	endtask	
	
	task check_art_flags(
		input [98:0] data_read_input,
		output [3:0] predicted_flags,
		output bit signed [31:0] predicted_result,
		output operation_t read_op_code
		);
		bit signed[31:0] A_read,B_read;
		bit c,dummy;//carry bit
		bit[3:0] predicted_CRC_input,read_crc_input;	
		predicted_flags = 0;
		c = 0;
		{B_read,A_read,dummy,read_op_code,read_crc_input} = {data_read_input[96:89],data_read_input[85:78],data_read_input[74:67],data_read_input[63:56],data_read_input[52:45],data_read_input[41:34],data_read_input[30:23],data_read_input[19:12],data_read_input[8:1]};
	      case (read_op_code)
	        and_op:predicted_result = B_read & A_read;			        		
	        or_op: predicted_result = B_read | A_read;
	        add_op:
	        	begin
		        	{c,predicted_result} = $unsigned(B_read) + $unsigned(A_read);
		        	if((B_read >= 0) & (A_read >= 0) & (predicted_result < 0)) predicted_flags[2] = 1; //overflow flag prediction
		        	else if((B_read < 0) & (A_read < 0) & (predicted_result > 0)) predicted_flags[2] = 1; //overflow flag prediction
		        end
	        sub_op:
	        	begin
					{c,predicted_result} = $unsigned(B_read) - $unsigned(A_read);
		        	if((B_read >= 0) & (A_read < 0) & (predicted_result < 0)) predicted_flags[2] = 1; //overflow flag prediction
		        	else if((B_read < 0) & (A_read >= 0) & (predicted_result >= 0)) predicted_flags[2] = 1; //overflow flag prediction      	
		        end	
	      endcase 
	      if(c == 1) predicted_flags[3] = 1;
	      if(predicted_result == 0) predicted_flags[1] = 1; //zero flag prediction
	      if(predicted_result < 0) predicted_flags[0] = 1; //negative flag prediction
	endtask
	
	
	function bit[3:0] calc_CRC_input(int B, int A, bit[2:0] op_code);
		bit[67:0] data_in;
		static bit[3:0] lfsr_q = 0;
		bit[3:0] lfsr_c;
		data_in = {B,A,1'b1,op_code};
		lfsr_c[0] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[45] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[66];
	    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[42] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63] ^ data_in[65] ^ data_in[66] ^ data_in[67];
	    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[64] ^ data_in[66] ^ data_in[67];
	    lfsr_c[3] = lfsr_q[1] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[59] ^ data_in[62] ^ data_in[63] ^ data_in[65] ^ data_in[67];
		return lfsr_c; //CRC
	endfunction
	
	function bit[2:0] calc_CRC_output(int C, bit[3:0] flags);
		bit[36:0] data_in;
		static bit[2:0] lfsr_q = 3'b111;
		bit[2:0] lfsr_c;
		data_in = {C,1'b1,flags};
		lfsr_c[0] = lfsr_q[1] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[35];
	    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[2] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[35] ^ data_in[36];
	    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[36];
		return lfsr_c;
	endfunction	
	
	
	
	`include "coverage.svh"
	`include "tester.svh"
	`include "scoreboard.svh"
	`include "testbench.svh"
	
endpackage		
