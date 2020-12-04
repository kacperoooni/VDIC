class HLV_tester extends base_tester;
	`uvm_component_utils (HLV_tester)
	
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
endfunction

function int gen_number();
	int random_number;
	bit random_function;
	random_function = $random;
	case(random_function)
		1'b0: random_number = {32{1'b0}};
		1'b1: random_number = {32{1'b1}};
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
	phase.raise_objection(this);
///////////////////////TESTER CODE/////////////////////////////////////
	transmission_counter = 0;
		forever
			begin
				command.reset_now = 0;
				A_generated = gen_number();
				B_generated = gen_number();
				op_code = get_op();
				CRC_input = calc_CRC_input(B_generated, A_generated, op_code);
				command.data_to_send = {DATA(B_generated),DATA(A_generated),CTL({1'b0,op_code,CRC_input})};
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