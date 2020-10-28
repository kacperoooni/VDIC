`timescale 1ns/1ps
module top_TB;



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
	
	

localparam TRANSMISSION_CYCLES = 10000;

bit clk;
bit sin;
wire sout;
bit rst_n;
	


	

	
operation_t op_code;
state_tester_t state_tester;
state_deserializer_t state_deserializer;	
function_t gen_function;	
mtm_Alu DUT (.clk, .rst_n, .sin, .sout );	


function operation_t get_op();
      bit [2:0] op_choice;
      op_choice = $random;
      case (op_choice)
        3'b000 : return and_op;
        3'b001 : return or_op;
        3'b100 : return add_op;
        3'b101 : return sub_op;
//        3'b111 : return no_op;
      endcase // case (op_choice)
   endfunction// : get_op
   
function function_t get_function();
      bit [3:0] function_choice;
      function_choice = $random;
      case (function_choice)
        1 : return GEN_NORMAL_OPERATION;
	    6 : return GEN_NORMAL_OPERATION;
	    7 : return GEN_NORMAL_OPERATION;
	    8 : return GEN_NORMAL_OPERATION;  
        2 : return GEN_CRC_ERROR;
        3 : return GEN_BYTE_ERROR;
        4 : return GEN_RESET;
        5 : return GEN_UNKNOWN_OP;
      endcase // case (op_choice)
   endfunction// : get_op   
   

function int gen_number();
	int random_number;
	bit [1:0] random_function;
	random_function = $random;
	case(random_function)
		1'b00: random_number = {32{1'b0}};
		1'b11: random_number = {32{1'b1}};
		default: random_number = $random;
	endcase
	return random_number;
endfunction


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


initial begin : clk_gen
	  #10
      clk = 0;
      forever begin : clk_frv
         #10;
         clk = ~clk;
      end
   end	


///////////////////////TESTER VARIABLES/////////////////////////////
int A_generated;
int B_generated;
byte loop_iterations_data;
bit[98:0] data_to_send;
bit[3:0] CRC_input;
bit[31:0] transmission_counter;
///////////////////////TESTER FSM/////////////////////////////////////
initial
	begin
		state_tester = INIT;
		forever
			begin
				case(state_tester)
					INIT:
						begin
							sin = 1;
							rst_n = 1;
							#320;
							rst_n = 0;
							#20;
							rst_n = 1;
							#200;
							state_tester = GENERATE_FUNCTION;
						end
					GENERATE_FUNCTION:
						begin
							state_tester = SEND;
							gen_function=get_function();
							case(gen_function)
								GEN_NORMAL_OPERATION:
									begin
										A_generated = gen_number();
										B_generated = gen_number();
										op_code = get_op();
										CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
										data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
									end
								GEN_CRC_ERROR:
									begin
										A_generated = gen_number();
										B_generated = gen_number();
										op_code = get_op();
										CRC_input = calc_CRC_input(B_generated, A_generated, op_code)+1;
										data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
									end
								GEN_BYTE_ERROR:
									begin
										A_generated = gen_number();
										B_generated = gen_number();
										op_code = get_op();
										CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
										data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
										data_to_send = {{11{1'b1}},data_to_send[87:0]};
									end
								GEN_RESET:
									begin
										state_tester = RESET;
									end	
								GEN_UNKNOWN_OP:
									begin
										A_generated = gen_number();
										B_generated = gen_number();
										op_code = no_op;
										CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
										data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
									end
							endcase	
								@(posedge clk);
						end	
					RESET:
						begin
							rst_n = 1;
							#320;
							rst_n = 0;
							#20;
							rst_n = 1;
							#200;
							state_tester = GENERATE_FUNCTION;
						end
					SEND:	
						begin
							loop_iterations_data = 99;
							repeat(99)
								begin
									@(negedge clk);
									loop_iterations_data--;
									sin = data_to_send[loop_iterations_data];
								end
							state_tester = DONE_SENDING;
						end
					DONE_SENDING:
						begin
							transmission_counter++;
							sin = 1;
							#1200;
							if(transmission_counter == TRANSMISSION_CYCLES)
								begin
									$display("%0t %0g",$time, $get_coverage());
									$finish;
								end	
							else
								state_tester = GENERATE_FUNCTION;
						end	
				endcase
			end		
	end		


///////////////SCOREBOARD DESERIALIZER VARIABLES////////////////////////////////////////
byte read_iterator_input;
bit[3:0] read_crc_input;
bit[98:0] data_read_input,data_read_input_nxt;
int A_read,B_read;
operation_t read_op_code;
byte read_iterator_output;	
bit[4:0] read_flags;
bit[2:0] read_err_flags;	
bit[54:0] read_data_output;	
int read_number_output;
bit[2:0] read_crc_output;	
bit dummy,read_parity_bit;
///////////////SCOREBOARD  INPUT DESERIALIZER //////////////////////////////////////	
initial
	begin
		forever
			begin
				read_iterator_input = 99;
				@(negedge sin);
				repeat(99)
					begin
						@(posedge clk);
						read_iterator_input--;
						data_read_input_nxt[read_iterator_input] = sin;
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
							@(negedge clk);
							state_deserializer = WAIT_FOR_OUTPUT;
						end
				endcase
			end	
 end
 
 
 initial begin
	 //INIT VALUES////////////////////////////////////////
	   bit c;//carry bit
	   int predicted_result;
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
				          $error ("FAILED: A: %0d  B: %0d  op: %s result: %0d predicted_result: %0d flags: %0b predicted_flags: %0b output crc: %0h predicted output crc: %0h",
				                  A_read, B_read, read_op_code.name(), read_number_output, predicted_result, read_flags, predicted_flags, read_crc_output, predicted_CRC_output);
					      $stop; 
				        end
			        else
				        $display("DATA OK!!");
			predicted_flags = 0; // RESET FLAGS
			c = 0;// RESET CARRY
		   end	
		//IF OUTPUT MESSAGE WAS ONLY CTL///////////////////////////////////////
	   else if(output_type_rec == 3'b011)
		   begin
		  predicted_parity_bit = Check_parity(predicted_err_flags); //CALCULATING PARITY BIT
			   if ((predicted_err_flags != read_err_flags)|(predicted_parity_bit != read_parity_bit)) begin
		          $error ("FAILED: predicted_err_flags: %0b read_err_flags: %0b, predicted_parity_bit: %0b read_parity_bit: %0b",
		                   predicted_err_flags, read_err_flags, predicted_parity_bit, read_parity_bit);
			   		$stop; end
			   else $display("CLT_OK: predicted_err_flags: %0b read_err_flags: %0b, predicted_parity_bit: %0b read_parity_bit: %0b",
		                   predicted_err_flags, read_err_flags, predicted_parity_bit, read_parity_bit);
			   
		   end
		   @(state_deserializer == WAIT_FOR_OUTPUT);
   		end : scoreboard
end

///////////////COVERAGE DESERIALIZER VARIABLES////////////////////////////////////////
byte read_iterator_input_cg;
bit[3:0] read_crc_input_cg;
bit[98:0] data_read_input_cg;
int A_read_cg,B_read_cg;
bit dummy_cg;
operation_t read_op_code_cg,read_op_code_cg_prv;
bit was_reset;
bit[3:0] predicted_flags_cg, predicted_flags_cg_prv; 
bit[2:0] predicted_err_flags_cg,predicted_err_flags_cg_prv; 


covergroup cg_op_all;
      coverpoint read_op_code_cg {
         // #A1 test all operations
         bins A1_all_ops[] = {and_op,or_op,add_op,sub_op};
      }
endgroup

covergroup cg_op_all_br;
      coverpoint read_op_code_cg_prv {
         // #A1 test all operations
         bins A1_all_ops[] = {and_op,or_op,add_op,sub_op};
      }
endgroup


covergroup cg_op_all_HLV;
      OP: coverpoint read_op_code_cg {
         // #B1 test all operations with highest values
         bins B1_all_ops_HLV[] = {and_op,or_op,add_op,sub_op};
	  }
	  A: coverpoint A_read_cg{
		 bins B1_A_values[] = {-1, 0};
	  } 
	  B: coverpoint B_read_cg{
		 bins B1_B_values[] = {-1, 0};
	  } 
	  cross A,B,OP;
      
endgroup

covergroup cg_err_flags_cov;
      coverpoint predicted_err_flags_cg {
         // #B2 test all error flags
         bins B2_read_err_flags[] = {3'b100,3'b010,3'b001};
      }
endgroup


covergroup cg_err_flags_cov_br;
      coverpoint predicted_err_flags_cg_prv {
         // #B4 test all error flags
         bins B1_read_err_flags[] = {3'b100,3'b010,3'b001};
      }
endgroup

covergroup cg_flags_cov;
      coverpoint predicted_flags_cg {
         //  test all error flags
         bins all_flags[] = {[0:$]};
	     ignore_bins all_flags_ignored = {3,7,10,11,14,15};
      }
endgroup

covergroup cg_flags_cov_br;
      coverpoint predicted_flags_cg_prv {
         //  test all flags
         bins all_flags[] = {[0:$]};
	     ignore_bins all_flags_ignored = {3,7,10,11,14,15};
      }
endgroup



initial
	begin
		bit c;//carry bit
		int predicted_result;
		bit[3:0] predicted_CRC_input;
		cg_op_all cg_op_all_ob;
		cg_op_all cg_op_ar_ob;
		cg_op_all_br cg_op_br_ob;
		cg_err_flags_cov cg_err_flags_cov_ob;
		cg_err_flags_cov  cg_err_flags_cov_ar_ob;
		cg_err_flags_cov_br cg_err_flags_cov_br_ob;
		cg_flags_cov cg_flags_cov_ob;
		cg_flags_cov cg_flags_cov_ar_ob;
		cg_flags_cov_br cg_flags_cov_br_ob;
		cg_op_all_HLV cg_op_all_HLV_ob;	
		cg_op_all_ob = new();
		cg_op_all_ob.option.name = "A1.Test all operations";
		cg_op_ar_ob = new();
		cg_op_ar_ob.option.name = "A2.Test all operations after reset";
		cg_op_br_ob = new();
		cg_op_br_ob.option.name = "A3.Test reset after all operations";
		cg_err_flags_cov_ob = new();
		cg_err_flags_cov_ob.option.name = "B2.Simulate all error flags";
		cg_err_flags_cov_ar_ob = new();
		cg_err_flags_cov_ar_ob.option.name = "B3.Test all error flags after reset";
		cg_err_flags_cov_br_ob = new();
		cg_err_flags_cov_br_ob.option.name = "B4.Test reset after all error flags";
		cg_flags_cov_ob = new();
		cg_flags_cov_ob.option.name = "B5.Simulate all arithmetic flags";
		cg_flags_cov_ar_ob = new();
		cg_flags_cov_ar_ob.option.name = "B6.Test all arithmetic flags after reset";
		cg_flags_cov_br_ob = new();
		cg_flags_cov_br_ob.option.name = "B7.Test reset after all arithmetic flags ";
		cg_op_all_HLV_ob = new();
		cg_op_all_HLV_ob.option.name = "B1.Simulate all operations with the lowest and highest possible input values (A and B)";
		forever
			begin
				read_iterator_input_cg = 99;
				@(negedge sin);
				repeat(99)
					begin
						@(posedge clk);
						read_iterator_input_cg--;
						data_read_input_cg[read_iterator_input_cg] = sin;
					end	
		   predicted_err_flags_cg = 0;
		   //CHECK INPUT BYTES NUMBER///////////////////////////
		   if((data_read_input_cg[10] == 0 ) & (data_read_input_cg[9] == 1)) // OK NUMBER
			   begin
				   {B_read_cg,A_read_cg,dummy_cg,read_op_code_cg,read_crc_input_cg} = {data_read_input_cg[96:89],data_read_input_cg[85:78],data_read_input_cg[74:67],data_read_input_cg[63:56],data_read_input_cg[52:45],data_read_input_cg[41:34],data_read_input_cg[30:23],data_read_input_cg[19:12],data_read_input_cg[8:1]};
				   read_op_code_cg_prv = read_op_code_cg;
			   		predicted_CRC_input = calc_CRC_input(B_read_cg, A_read_cg, read_op_code_cg);
				   	if(read_crc_input_cg != predicted_CRC_input) predicted_err_flags_cg[1] = 1; //WRONG INPU CRC CODE
				   	else if((read_op_code_cg != add_op)&(read_op_code_cg!= and_op)&(read_op_code_cg != or_op)&(read_op_code_cg != sub_op)) predicted_err_flags_cg[0] = 1; //WRONG OP CODE
			   end
		   else
		   	 predicted_err_flags_cg[2] = 1; //WRONG NUMBER
		   //IF OUTPUT MESSAGE WAS DATA////////////////////////
		   if(predicted_err_flags_cg == 3'b000)
			   begin
			      case (read_op_code_cg)
			        and_op:predicted_result = B_read_cg & A_read_cg;			        		
			        or_op: predicted_result = B_read_cg | A_read_cg;
			        add_op:
			        	begin
				        	{c,predicted_result} = $unsigned(B_read) + $unsigned(A_read);
				        	if((B_read_cg >= 0) & (A_read_cg >= 0) & (predicted_result < 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        	else if((B_read_cg < 0) & (A_read_cg < 0) & (predicted_result > 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        end
			        sub_op:
			        	begin
							{c,predicted_result} = $unsigned(B_read) - $unsigned(A_read);
				        	if((B_read_cg >= 0) & (A_read_cg < 0) & (predicted_result < 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        	else if((B_read_cg < 0) & (A_read_cg >= 0) & (predicted_result >= 0)) predicted_flags_cg[2] = 1; //overflow flag prediction      	
				        end	
			      endcase 
			      if(c == 1) predicted_flags_cg[3] = 1;
			      if(predicted_result == 0) predicted_flags_cg[1] = 1; //zero flag prediction
			      if(predicted_result < 0) predicted_flags_cg[0] = 1; //negative flag prediction
			      
			      cg_op_all_ob.sample();
			      cg_flags_cov_ob.sample();
			      cg_op_all_HLV_ob.sample();
			      if(was_reset == 1)
				      begin
				      	cg_op_ar_ob.sample();
					    cg_op_br_ob.sample(); 
					    cg_flags_cov_ar_ob.sample(); 
					    cg_flags_cov_br_ob.sample(); 
				      end   
				 read_op_code_cg_prv = read_op_code_cg;
				 predicted_flags_cg_prv = predicted_flags_cg;     
				 predicted_err_flags_cg_prv = 0;
			   end
		   else
			   begin
				  cg_err_flags_cov_ob.sample(); 
			      if(was_reset == 1)
			      	begin
				      	cg_err_flags_cov_br_ob.sample();
				      	cg_err_flags_cov_ar_ob.sample();
			      	end
			      predicted_err_flags_cg_prv = predicted_err_flags_cg;	
			      read_op_code_cg_prv = no_op;
			      predicted_flags_cg_prv = 0;
			   end   	
			   	was_reset = 0;
				predicted_flags_cg = 0; // RESET FLAGS
				c = 0;// RESET CARRY
			end
end
		


always@(negedge rst_n)
	begin
		was_reset <= 1;
	end


endmodule	