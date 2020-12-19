module alu_tester_module(
	alu_bfm bfm_tester
	);
	
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
	
localparam TRANSMISSION_CYCLES = 50000;	
operation_t op_code;
state_tester_t state_tester;
function_t gen_function;

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
		2'b00: random_number = {32{1'b0}};
		2'b11: random_number = {32{1'b1}};
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




	
	
///////////////////////TESTER VARIABLES/////////////////////////////
bit signed[31:0] A_generated;
bit signed[31:0] B_generated;
bit[7:0] loop_iterations_data;
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
							bfm_tester.sin = 1;
							bfm_tester.rst_n = 1;
							#320;
							bfm_tester.rst_n = 0;
							#20;
							bfm_tester.rst_n = 1;
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
								@(posedge bfm_tester.clk);
						end	
					RESET:
						begin
							bfm_tester.rst_n = 1;
							#320;
							bfm_tester.rst_n = 0;
							#20;
							bfm_tester.rst_n = 1;
							#200;
							state_tester = GENERATE_FUNCTION;
						end
					SEND:	
						begin
							loop_iterations_data = 99;
							repeat(99)
								begin
									@(negedge bfm_tester.clk);
									loop_iterations_data--;
									bfm_tester.sin = data_to_send[loop_iterations_data];
								end
							state_tester = DONE_SENDING;
						end
					DONE_SENDING:
						begin
							transmission_counter++;
							bfm_tester.sin = 1;
							#1200;
							if(transmission_counter == TRANSMISSION_CYCLES)
								begin
									$display("SIMULATION RESULT: PASSED");
									$display("%0t %0g",$time, $get_coverage());
									$finish;
								end	
							else
								state_tester = GENERATE_FUNCTION;
						end	
				endcase
			end		
	end		

endmodule	