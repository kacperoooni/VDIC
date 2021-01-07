class sequence_item extends uvm_sequence_item;
//   `uvm_object_utils(sequence_item)

   rand bit signed[31:0]     A;
   rand bit signed[31:0]     B;
   rand operation_t          op_code;
   rand function_t 			 gen_function;
   bit [98:0]                data_to_send;
   bit                       reset_now;

   constraint data { A dist {32'd0:=100000, 32'hFFFF_FFFF:=100000, [32'h1:32'hFFFF_FFFF]:/100000};
                     B dist {32'd0:=100000, 32'hFFFF_FFFF:=100000, [32'h1:32'hFFFF_FFFF]:/100000};
	   				 op_code dist {sub_op :=1,add_op :=1,or_op :=1,and_op :=1,no_op :=0};
	   				 gen_function dist {GEN_NORMAL_OPERATION :=8, GEN_CRC_ERROR :=1, GEN_BYTE_ERROR := 1,GEN_RESET :=1,GEN_UNKNOWN_OP :=1};
	   			   } 

    function new(string name = "");
        super.new(name);
    endfunction : new

	// macros providing copy, compare, pack, record, print functions.
	// Individual functions can be enabled/disabled with the last
	// `uvm_field_*() macro argument.
    `uvm_object_utils_begin(sequence_item)
	    `uvm_field_int(A, UVM_ALL_ON)
        `uvm_field_int(B, UVM_ALL_ON)
        `uvm_field_enum(operation_t, op_code, UVM_ALL_ON)
        `uvm_field_enum(function_t, gen_function, UVM_ALL_ON)
        `uvm_field_int(data_to_send, UVM_ALL_ON)
        `uvm_field_int(reset_now, UVM_ALL_ON)
    `uvm_field_utils_end
    
    function string convert2string();
        string s;
        s = $sformatf("A: %2h  B: %2h ",
            A, B );
        return s;
    endfunction : convert2string

endclass : sequence_item
