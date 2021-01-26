/******************************************************************************
* DVT CODE TEMPLATE: example test
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_minmax_test
`define IFNDEF_GUARD_kg_alu_minmax_test

class  kg_alu_minmax_test extends kg_alu_base_test;

	`uvm_component_utils(kg_alu_minmax_test)

	function new(string name = "kg_alu_minmax_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this,
			"m_env.m_kg_alu_agent.m_sequencer.run_phase",
			"default_sequence",
			kg_alu_minmax_sequence::type_id::get());

       	// Create the env
		super.build_phase(phase);
	endfunction

endclass


`endif // IFNDEF_GUARD_kg_alu_minmax_test

