/******************************************************************************
* DVT CODE TEMPLATE: sequencer
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_sequencer
`define IFNDEF_GUARD_kg_alu_sequencer

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_sequencer
//
//------------------------------------------------------------------------------

class kg_alu_sequencer extends uvm_sequencer #(kg_alu_item);
	
	`uvm_component_utils(kg_alu_sequencer)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : kg_alu_sequencer

`endif // IFNDEF_GUARD_kg_alu_sequencer
