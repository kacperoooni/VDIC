module scoreboard(
	alu_bfm sb_bfm);

import alu_pkg::*;

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


function bit Check_parity(bit[2:0] err_flags_in);
	bit[6:0] data;
	bit parity_bit;
	byte i;
	parity_bit = 0;
	data = {1'b1,err_flags_in,err_flags_in};
	for(i = 0; i < 7; i++)
		parity_bit = parity_bit ^ data[i];
	return parity_bit;
endfunction	


state_deserializer_t state_deserializer;		
operation_t read_op_code;
///////////////SCOREBOARD DESERIALIZER VARIABLES////////////////////////////////////////
bit[7:0] read_iterator_input;
bit[3:0] read_crc_input;
bit[98:0] data_read_input,data_read_input_nxt;
bit signed[31:0] A_read,B_read;
bit[7:0] read_iterator_output;	
bit[4:0] read_flags;
bit[2:0] read_err_flags;	
bit[54:0] read_data_output;	
bit signed[31:0] read_number_output;
bit[2:0] read_crc_output;	
bit dummy,read_parity_bit;
///////////////SCOREBOARD  INPUT DESERIALIZER //////////////////////////////////////	
initial
	begin
		forever
			begin
				read_iterator_input = 99;
				@(negedge sb_bfm.sin);
				repeat(99)
					begin
						@(posedge sb_bfm.clk);
						read_iterator_input--;
						data_read_input_nxt[read_iterator_input] = sb_bfm.sin;
					end
				data_read_input = data_read_input_nxt;	
			end
	end		

//////////////SCOREBOARD  DESERIALIZER//////////////////////////////////
initial
	begin
		state_deserializer = WAIT_FOR_OUTPUT;
		forever
			begin			
				case(state_deserializer)	
 					WAIT_FOR_OUTPUT:
						begin
							read_number_output = 0;
							read_crc_output = 0;
							read_crc_input = 0;
							read_err_flags = 0;
							read_flags = 0;
							read_iterator_output = 54;
							read_data_output = 0;
							@(negedge sb_bfm.sout);
							@(posedge sb_bfm.clk);
							read_data_output[read_iterator_output] = sb_bfm.sout;
							read_iterator_output--;
							@(posedge sb_bfm.clk);
							read_data_output[read_iterator_output] = sb_bfm.sout;
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
									@(posedge sb_bfm.clk);
									read_data_output[read_iterator_output] = sb_bfm.sout;
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
									@(posedge sb_bfm.clk);
									read_data_output[read_iterator_output] = sb_bfm.sout;
									read_iterator_output--;
								end	
							read_err_flags = read_data_output[48:46];
							read_parity_bit = read_data_output[45];
							state_deserializer = DONE;	
						end
					DONE:
						begin
							@(negedge sb_bfm.clk);
							state_deserializer = WAIT_FOR_OUTPUT;
						end
				endcase
			end	
 end
 
 
 initial begin
	 //INIT VALUES////////////////////////////////////////
	   bit c;//carry bit
	   bit signed[31:0] predicted_result;
	   bit[2:0] predicted_CRC_output;
	   bit[3:0] predicted_flags;
	   bit[3:0] predicted_CRC_input;
	   bit[2:0] predicted_err_flags;
	   bit predicted_parity_bit;
	   bit[2:0] output_type_rec;
	 //FOREVER SCOREBOARD LOOP
   forever begin : scoreboard
	   @(posedge state_deserializer == DONE); 
	   predicted_err_flags = 0;
	   output_type_rec = read_data_output[54:52];
	   //CHECK INPUT BYTES NUMBER///////////////////////////
	   if((data_read_input[10] == 0 ) & (data_read_input[9] == 1)) // OK NUMBER
		   begin
			   {B_read,A_read,dummy,read_op_code,read_crc_input} = {data_read_input[96:89],data_read_input[85:78],data_read_input[74:67],data_read_input[63:56],data_read_input[52:45],data_read_input[41:34],data_read_input[30:23],data_read_input[19:12],data_read_input[8:1]};
		   		predicted_CRC_input = calc_CRC_input(B_read, A_read, read_op_code);
			   	if(read_crc_input != predicted_CRC_input) predicted_err_flags[1] = 1; //WRONG INPU CRC CODE
			   	else if((read_op_code != add_op)&(read_op_code != and_op)&(read_op_code != or_op)&(read_op_code != sub_op)) predicted_err_flags[0] = 1; //WRONG OP CODE
		   end
	   else
	   	 predicted_err_flags[2] = 1; //WRONG NUMBER
	   //IF OUTPUT MESSAGE WAS DATA////////////////////////
	   if(output_type_rec[2:1] == 2'b00 )
		   begin
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
		      predicted_CRC_output = calc_CRC_output(predicted_result, predicted_flags);
		      if((read_op_code == add_op)|(read_op_code == and_op)|(read_op_code == or_op)|(read_op_code == sub_op)) //CHECK IF OPCODE IS CORRECT
			        if ((predicted_result != read_number_output) | (predicted_flags != read_flags) | (predicted_CRC_output != read_crc_output))
				        begin
				 //         $error ("FAILED: A: %0d  B: %0d  op: %s result: %0d predicted_result: %0d flags: %0b predicted_flags: %0b output crc: %0h predicted output crc: %0h",
				 //                 A_read, B_read, read_op_code.name(), read_number_output, predicted_result, read_flags, predicted_flags, read_crc_output, predicted_CRC_output);
					        $error ("SIMULATION RESULT: FAILED");
					      	$finish; 
				        end
			predicted_flags = 0; // RESET FLAGS
			c = 0;// RESET CARRY
		   end	
		//IF OUTPUT MESSAGE WAS ONLY CTL///////////////////////////////////////
	   else if(output_type_rec == 3'b011)
		   begin
		  predicted_parity_bit = Check_parity(predicted_err_flags); //CALCULATING PARITY BIT
			   if ((predicted_err_flags != read_err_flags)|(predicted_parity_bit != read_parity_bit)) 
				   begin
		       //   $error ("FAILED: predicted_err_flags: %0b read_err_flags: %0b, predicted_parity_bit: %0b read_parity_bit: %0b",
		       //            predicted_err_flags, read_err_flags, predicted_parity_bit, read_parity_bit);
				   $error ("SIMULATION RESULT: FAILED");
			   	   $finish; 
				   end			   
		   end
		   @(state_deserializer == WAIT_FOR_OUTPUT);
   		end : scoreboard
end
endmodule 
