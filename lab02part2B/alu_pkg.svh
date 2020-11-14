

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
endpackage		
