/******************************************************************************
* DVT CODE TEMPLATE: sequence item
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_item
`define IFNDEF_GUARD_kg_alu_item

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_item
//
//------------------------------------------------------------------------------

class  kg_alu_item extends uvm_sequence_item;



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


	// macros providing copy, compare, pack, record, print functions.
	// Individual functions can be enabled/disabled with the last
	// `uvm_field_*() macro argument.
    `uvm_object_utils_begin(kg_alu_item)
	    `uvm_field_int(A, UVM_ALL_ON)
        `uvm_field_int(B, UVM_ALL_ON)
        `uvm_field_enum(operation_t, op_code, UVM_ALL_ON)
        `uvm_field_enum(function_t, gen_function, UVM_ALL_ON)
        `uvm_field_int(data_to_send, UVM_ALL_ON)
        `uvm_field_int(reset_now, UVM_ALL_ON)
    `uvm_field_utils_end
    

	function new (string name = "kg_alu_item");
		super.new(name);
	endfunction : new
//
//	// HINT UVM field macros don't work with unions and structs, you may have to override kg_alu_item.do_copy().
//	virtual function void do_copy(uvm_object rhs);
//		super.do_copy(rhs);
//	endfunction : do_copy
//
//	// HINT UVM field macros don't work with unions and structs, you may have to override kg_alu_item.do_pack().
//	virtual function void do_pack(uvm_packer packer);
//		super.do_pack(packer);
//	endfunction : do_pack
//
//	// HINT UVM field macros don't work with unions and structs, you may have to override kg_alu_item.do_unpack().
//	virtual function void do_unpack(uvm_packer packer);
//		super.do_unpack(packer);
//	endfunction : do_unpack
//
//	// HINT UVM field macros don't work with unions and structs, you may have to override kg_alu_item.do_print().
//	virtual function void do_print(uvm_printer printer);
//		super.do_print(printer);
//	endfunction : do_print

endclass :  kg_alu_item

`endif // IFNDEF_GUARD_kg_alu_item
