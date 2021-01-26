/******************************************************************************
* DVT CODE TEMPLATE: sequence item
* Created by kgaweda on Jan 26, 2021
* uvc_company = kg, uvc_name = alu_result
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_result_item
`define IFNDEF_GUARD_kg_alu_result_item

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_result_item
//
//------------------------------------------------------------------------------

class  kg_alu_result_item extends uvm_sequence_item;
	
	uvm_analysis_port #(kg_alu_item) m_collected_item_port;
	
    bit[54:0] read_data_output; 
    bit[4:0] read_flags; 
    bit[2:0] read_crc_output; 
    bit[2:0] read_err_flags;
    bit read_parity_bit;
    bit signed[31:0] read_number_output;


	`uvm_object_utils_begin(kg_alu_result_item)
		`uvm_field_int(read_data_output, UVM_DEFAULT)
		`uvm_field_int(read_flags, UVM_DEFAULT)
		`uvm_field_int(read_crc_output, UVM_DEFAULT)
		`uvm_field_int(read_err_flags, UVM_DEFAULT)
		`uvm_field_int(read_parity_bit, UVM_DEFAULT | UVM_UNSIGNED)
		`uvm_field_int(read_number_output, UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "kg_alu_result_item");
		super.new(name);
	endfunction : new


endclass :  kg_alu_result_item

`endif // IFNDEF_GUARD_kg_alu_result_item
