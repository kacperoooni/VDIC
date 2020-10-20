`timescale 1ns/1ps
module top_TB;

typedef enum bit[2:0] {and_op  = 3'b000,
                       or_op = 3'b001, 
                       add_op = 3'b100,
                       sub_op = 3'b101,
                       no_op = 3'b111} operation_t;



bit clk;
bit sin;
bit sout;
bit rst_n;	
operation_t op_code;
mtm_Alu DUT (.clk, .rst_n, .sin, .sout );	
	
function operation_t get_op();
      bit [2:0] op_choice;
      op_choice = $random;
      case (op_choice)
        3'b000 : return and_op;
        3'b001 : return or_op;
        3'b100 : return add_op;
        3'b101 : return sub_op;
        3'b111 : return no_op;
      endcase // case (op_choice)
   endfunction// : get_op	

function int gen_number();
	int random_number;
	random_number = $random;
	return random_number;
endfunction


function bit[3:0] calc_CRC_input(int B, int A, bit[2:0] op_code);
	bit[67:0] CRC_helper;
	bit[3:0] CRC;
	CRC_helper = {B,A,1'b1,op_code};
	CRC = CRC_helper^4 + CRC_helper + 1;
	return CRC;
endfunction

function bit[3:0] calc_CRC_output(int C, bit[3:0] flags);
	bit[36:0] CRC_helper;
	bit[3:0] CRC;
	CRC_helper = {C,1'b1,flags};
	CRC = CRC_helper^3 + CRC_helper + 1;
	return CRC;
endfunction


initial begin : clk_gen
      clk = 0;
      forever begin : clk_frv
         #10;
         clk = ~clk;
      end
   end	


int A_generated;
int B_generated;
bit[3:0] loop_iterations_data = 0;
bit[4:0] loop_iterations_bits = 0;



always@(posedge clk)
	begin
		if(loop_iterations == 0)
			begin
				A_generated = gen_number();
				B_generated = gen_number();
			end
		if(loop_ite)	
		case(loop_iterations_bits)
			0: 


endmodule		