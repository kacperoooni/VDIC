`timescale 1ns/1ps
module top_TB;

typedef enum bit[2:0] {and_op  = 3'b000,
                       or_op = 3'b001, 
                       add_op = 3'b100,
                       sub_op = 3'b101,
                       no_op = 3'b111} operation_t;

typedef enum bit[2:0] {INIT  = 3'b000,
                       RESET = 3'b001, 
                       SEND = 3'b100,
                       WAIT_FOR_OUTPUT = 3'b101,
                       READ_OUTPUT_DATA = 3'b111,
                       READ_OUTPUT_CLT = 3'b110,
                       DONE = 3'b010,
                       GENERATE_FUNCTION = 3'b011} state_t;
	
typedef enum bit[3:0] {GEN_NORMAL_OPERATION  = 1,
                       GEN_CRC_ERROR = 2, 
                       GEN_BYTE_ERROR = 3,
                       GEN_RESET = 4,
                       GEN_UNKNOWN_OP = 5} function_t;

localparam TRANSMISSION_CYCLES = 100000;

bit clk;
bit sin;
wire sout;
bit rst_n;	
operation_t op_code;
state_t state;
function_t gen_function;	
mtm_Alu DUT (.clk, .rst_n, .sin, .sout );	


covergroup op_cov;

      option.name = "cg_op_cov";

      coverpoint op_set {
         // #A1 test all operations
         bins A1_single_cycle[] = {and_op,or_op,add_op,sub_op};

         // #A2 test all operations after reset
         bins A2_rst_opn[] = (rst_op => [add_op:mul_op]);

         // #A3 test reset after all operations
         bins A3_opn_rst[] = ([add_op:mul_op] => rst_op);

         // #A4 multiply after single-cycle operation
         bins A4_sngl_mul[] = ([add_op:xor_op],no_op => mul_op);

         // #A5 single-cycle operation after multiply
         bins A5_mul_sngl[] = (mul_op => [add_op:xor_op], no_op);

         // #A6 two operations in row
         bins A6_twoops[] = ([add_op:mul_op] [* 2]);

         // bins manymult = (mul_op [* 3:5]);
      }

   endgroup


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
      bit [2:0] function_choice;
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

function bit[3:0] calc_CRC_output(int C, bit[3:0] flags);
	bit[36:0] data_in;
	static bit[3:0] lfsr_q = 0;
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
byte loop_iterations_data = 0;
bit[98:0] data_to_send;
bit[3:0] CRC_input;

/*

initial	begin
	sin = 1;
	rst_n = 1;
	#320;
	rst_n = 0;
	#20;
	rst_n = 1;
	#20;
	repeat(1000) begin
			if(loop_iterations_data == 0)
				begin
					A_generated = gen_number();
					B_generated = gen_number();
					op_code = get_op();
					CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
					data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
				end	
			@(posedge clk);	
			sin = data_to_send[99-loop_iterations_data];	
			if(loop_iterations_data == 99)
				begin
				loop_iterations_data = 0;
				end
			else
				loop_iterations_data++;
	end
	$finish;
end
*/
bit[54:0] read_data;
byte read_iterator;
int read_number;
bit[4:0] read_flags;
bit[2:0] read_crc;
bit[2:0] read_err_flags;
bit[31:0] transmission_counter;



initial
	begin
		state = INIT;
		forever
			begin
				case(state)
					INIT:
						begin
							sin = 1;
							rst_n = 1;
							#320;
							rst_n = 0;
							#20;
							rst_n = 1;
							#200;
							state = GENERATE_FUNCTION;
						end
					GENERATE_FUNCTION:
						begin
							read_number = 0;
							read_crc = 0;
							read_err_flags = 0;
							read_flags = 0;
							state = SEND;
							gen_function=get_function();
							case(gen_function)
								GEN_NORMAL_OPERATION:
									begin
										A_generated = gen_number();
										B_generated = gen_number();
										op_code = get_op();
										CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
										data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
										state = SEND;
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
										state = RESET;
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
							state = GENERATE_FUNCTION;
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
							state = WAIT_FOR_OUTPUT;
						end	
					WAIT_FOR_OUTPUT:
						begin
							read_iterator = 54;
							read_data = 0;
							@(negedge sout);
							@(posedge clk);
							read_data[read_iterator] = sout;
							read_iterator--;
							@(posedge clk);
							read_data[read_iterator] = sout;
							read_iterator--;
							if(read_data[read_iterator+1] == 1)
								state = READ_OUTPUT_CLT;
							else
								state = READ_OUTPUT_DATA;
						end	
					READ_OUTPUT_DATA:
						begin
							repeat(53)
								begin
									@(posedge clk);
									read_data[read_iterator] = sout;
									read_iterator--;
								end
							read_number = {read_data[52:45],read_data[41:34],read_data[30:23],read_data[19:12]};
							read_flags = read_data[7:4];
							read_crc = read_data[3:1];	
							state = DONE;
						end	
					READ_OUTPUT_CLT:	
						begin
							repeat(9)
								begin
									@(posedge clk);
									read_data[read_iterator] = sout;
									read_iterator--;
								end	
							read_err_flags = read_data[48:46];
							state = DONE;	
						end
					DONE:
						begin
							transmission_counter++;
							sin = 1;
							#100;
							if(transmission_counter == TRANSMISSION_CYCLES)
								$finish;
							else
								state = GENERATE_FUNCTION;
							
						end	
				endcase
			end		
	end		
/*
initial 
	begin // OUTPUT READ

	repeat(1000)
		begin
			read_iterator = 54;
			read_data = 0;
			@(negedge sout);
			@(posedge clk);
			read_data[read_iterator] = sout;
			read_iterator--;
			@(posedge clk);
			read_data[read_iterator] = sout;
			read_iterator--;
			if(read_data[read_iterator+1] == 1)
				begin
					$finish;
				end	
			else	
				begin
					repeat(53)
						begin
							@(posedge clk);
							read_data[read_iterator] = sout;
							read_iterator--;
						end
					read_number = {read_data[52:45],read_data[41:34],read_data[30:23],read_data[19:12]};
					read_flags = read_data[7:4];
					read_crc = read_data[3:1];	
						$finish;
				end		
		end
		
	end

*/

endmodule	