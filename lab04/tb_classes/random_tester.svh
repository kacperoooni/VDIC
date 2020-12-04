
class random_tester extends base_tester;
	`uvm_component_utils (random_tester)
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	


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
      function_choice = $urandom_range(8,1);
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




	
task run_phase(uvm_phase phase);
	command_s command;
///////////////////////TESTER VARIABLES/////////////////////////////
	operation_t op_code;
	function_t gen_function;
	bit signed[31:0] A_generated;
	bit signed[31:0] B_generated;
	bit[98:0] data_to_send;
	bit[3:0] CRC_input;
	bit[31:0] transmission_counter;
	localparam TRANSMISSION_CYCLES = 50000;	
///////////////////////TESTER CODE/////////////////////////////////////
	phase.raise_objection(this);
	transmission_counter = 0;
		forever
			begin
				gen_function=get_function();
				command.reset_now = 0;
				case(gen_function)
					GEN_NORMAL_OPERATION:
						begin
							A_generated = gen_number();
							B_generated = gen_number();
							op_code = get_op();
							CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
							command.data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
						end
					GEN_CRC_ERROR:
						begin
							A_generated = gen_number();
							B_generated = gen_number();
							op_code = get_op();
							CRC_input = calc_CRC_input(B_generated, A_generated, op_code)+1;
							command.data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
						end
					GEN_BYTE_ERROR:
						begin
							A_generated = gen_number();
							B_generated = gen_number();
							op_code = get_op();
							CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
							command.data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
							command.data_to_send = {{11{1'b1}},command.data_to_send[87:0]};
						end
					GEN_RESET:
						begin
							command.reset_now = 1;
						end	
					GEN_UNKNOWN_OP:
						begin
							A_generated = gen_number();
							B_generated = gen_number();
							op_code = no_op;
							CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
							command.data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
						end
				endcase
				//$display ("GENERATED: A: %d  B: %d  op: %s  %s ",A_generated,B_generated, op_code.name(), gen_function.name());
				command_port.put(command);
				transmission_counter++;
				if(transmission_counter == TRANSMISSION_CYCLES)
					begin
						repeat(3) 
						$display("//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
						$display("/////////////////////////////////////////////////RANDOM SIMULATION RESULT: PASSED/////////////////////////////////////////////////////");
						$display("////////////////////////////////////////////////////Functional coverage: %0g%%/////////////////////////////////////////////////////////", $get_coverage());
						repeat(3) 
						$display("//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
						$finish;	
					end
			end	
			phase.drop_objection(this);
	endtask
endclass	