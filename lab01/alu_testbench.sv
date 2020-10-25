`timescale 1ns/1ps
module top_TB;



typedef enum bit[2:0] {WAIT_FOR_OUTPUT = 3'b101,
                       READ_OUTPUT_DATA = 3'b111,
                       READ_OUTPUT_CLT = 3'b110,
                       READ_INPUT = 3'b100,
                       DONE = 3'b010} state_scoreboard_t;	
	
	
	
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
	
	

localparam TRANSMISSION_CYCLES = 100000;

bit clk;
bit sin;
wire sout;
bit rst_n;
	


	

	
operation_t op_code;
state_tester_t state_tester;
state_scoreboard_t state_scoreboard;	
function_t gen_function;	
mtm_Alu DUT (.clk, .rst_n, .sin, .sout );	

/*
covergroup op_cov;

      option.name = "cg_op_cov";

      coverpoint op_code {
         // #A1 test all operations
         bins A1_single_cycle[] = {and_op,or_op,add_op,sub_op};

         // #A2 test all operations after reset
        // bins A2_rst_opn[] = (rst_op => [and_op:sub_op];

         // #A3 test reset after all operations
        // bins A3_opn_rst[] = (and_op,or_op,add_op,sub_op => rst_op);

      }

   endgroup

covergroup err_flags_cov;

      option.name = "cg_err_flags_cov";

      coverpoint read_err_flags {
         // #A1 test all error flags
         bins B1_read_err_flags[] = {3'b100,3'b010,3'b001,3'b000};
      }

endgroup

covergroup op_after_reset_cov;

      option.name = "op_after_reset_cov";

      coverpoint op_code {
         // #A1 test all operations after reset
         bins op_after_reset_cov[] = {and_op,or_op,add_op,sub_op};
      }

endgroup

op_cov oc;
err_flags_cov err_f_c;
op_after_reset_cov op_ar_c;

initial 
	begin  
      oc = new(); //test all opcodes
      err_f_c = new();  //test all err flags
      forever 
	     begin
	         @(state == DONE);
	         oc.sample();
	         err_f_c.sample();
      	end
	end 

initial
	begin
		op_ar_c = new(); //test all operations after reset
		forever 
			begin
				@(state == RESET);
				@(state == DONE);
				op_ar_c.sample();
			end
	end
*/
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
	static bit[2:0] lfsr_q = 0;
	bit[3:0] lfsr_c;
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


initial begin : clk_gen
	  #10
      clk = 0;
      forever begin : clk_frv
         #10;
         clk = ~clk;
      end
   end	



int A_generated;
int B_generated;
byte loop_iterations_data;
bit[98:0] data_to_send;
bit[3:0] CRC_input;
bit[31:0] transmission_counter;

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

//------------------------------------------------------------------------------
// Scoreboard
//------------------------------------------------------------------------------

byte read_iterator_input,read_iterator_output;
int read_number_output;
bit[2:0] read_crc_output;
bit[3:0] read_crc_input;
bit[4:0] read_flags;
bit[2:0] read_err_flags;
bit[98:0] data_read_input,data_read_input_nxt;
bit[54:0] read_data_output;
int A_read,B_read;
operation_t read_op_code; 	
bit dummy,was_read_data,was_read_ctl;
	
initial
	begin
		forever
			begin
				read_iterator_input = 99;
				@(negedge sin);
				repeat(99)
					begin
						@(posedge clk)
						read_iterator_input--;
						data_read_input_nxt[read_iterator_input] = sin;
					end
				data_read_input = data_read_input_nxt;	
			end
	end		


initial
	begin
		state_scoreboard = WAIT_FOR_OUTPUT;
		forever
			begin			
				case(state_scoreboard)	
 					WAIT_FOR_OUTPUT:
						begin
							read_number_output = 0;
							read_crc_output = 0;
							read_crc_input = 0;
							read_err_flags = 0;
							read_flags = 0;
							was_read_data = 0;
							was_read_ctl = 0;
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
								state_scoreboard = READ_OUTPUT_CLT;
							else
								state_scoreboard = READ_OUTPUT_DATA;
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
							was_read_data = 1;
							state_scoreboard = DONE;
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
							was_read_ctl = 1;
							state_scoreboard = DONE;	
						end
					DONE:
						begin
							@(negedge clk);
							state_scoreboard = WAIT_FOR_OUTPUT;
						end
				endcase
			end	
 end
 
 
 
   always @(state_scoreboard == DONE) begin : scoreboard
	   bit c;
	   int predicted_result;
	   bit[2:0] predicted_CRC_output;
	   bit[3:0] predicted_flags;
	   bit[3:0] predicted_CRC_input;
	   bit[2:0] predicted_err_flags;
	   predicted_err_flags = 0;
	   if(data_read_input[10] == 0 & data_read_input[9] == 1)
		   begin
		   		{B_read,A_read,dummy,read_op_code,read_crc_input} = {data_read_input[96:89],data_read_input[85:78],data_read_input[74:67],data_read_input[63:56],data_read_input[52:45],data_read_input[41:34],data_read_input[30:23],data_read_input[19:12],data_read_input[8:1]};
		   		predicted_CRC_input = calc_CRC_input(B_read, A_read, read_op_code);
			   	if(read_crc_input != predicted_CRC_input) predicted_err_flags[1] = 1;
			   	else if((read_op_code != add_op)|(read_op_code != and_op)|(read_op_code != or_op)|(read_op_code != sub_op)) predicted_err_flags[0] = 1;
		   end
	   else
	   	 predicted_err_flags[2] = 1;
	   
	   
	   
	   
	   if(was_read_data == 1)
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
		      
		      //DOTO CRC AND PARITY BIT
		      
		      
		      
		      if (read_op_code != no_op) 
			        if ((predicted_result != read_number_output) | (predicted_flags != read_flags))
				        begin
				          $error ("FAILED: A: %0d  B: %0d  op: %s result: %0d predicted_result: %0d flags: %0b predicted_flags: %0b",
				                  A_read, B_read, read_op_code.name(), read_number_output, predicted_result, read_flags, predicted_flags);
					      $stop; 
				        end
			        else
				        $display("DATA OK!!");
			predicted_flags = 0;
			c = 0;
		   end		   
	   else if(was_read_ctl == 1)
		   	begin
			   if (predicted_err_flags != read_err_flags)
		          $error ("FAILED: predicted_flags: %0b read_err_flags: %0b",
		                   predicted_err_flags, read_err_flags);
			   else $display("CLT OK!!!");
			end   
   		end : scoreboard




endmodule	