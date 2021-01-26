/******************************************************************************
* DVT CODE TEMPLATE: sequence library
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_seq_lib
`define IFNDEF_GUARD_kg_alu_seq_lib

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_base_sequence
//
//------------------------------------------------------------------------------

virtual class kg_alu_base_sequence extends uvm_sequence#(kg_alu_item);
	
	`uvm_declare_p_sequencer(kg_alu_sequencer)

	function new(string name="kg_alu_base_sequence");
		super.new(name);
	endfunction : new

	virtual task pre_body();
		uvm_phase starting_phase = get_starting_phase();
		if (starting_phase!=null) begin
			`uvm_info(get_type_name(),
				$sformatf("%s pre_body() raising %s objection",
					get_sequence_path(),
					starting_phase.get_name()), UVM_MEDIUM)
			starting_phase.raise_objection(this);
		end
	endtask : pre_body

	virtual task post_body();
		uvm_phase starting_phase = get_starting_phase();
		if (starting_phase!=null) begin
			`uvm_info(get_type_name(),
				$sformatf("%s post_body() dropping %s objection",
					get_sequence_path(),
					starting_phase.get_name()), UVM_MEDIUM)
			starting_phase.drop_objection(this);
		end
	endtask : post_body

endclass : kg_alu_base_sequence

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_example_sequence
//
//------------------------------------------------------------------------------

class kg_alu_random_sequence extends kg_alu_base_sequence;

	// Add local random fields and constraints here

	`uvm_object_utils(kg_alu_random_sequence)

	function new(string name="kg_alu_random_sequence");
		super.new(name);
	endfunction : new
	
	kg_alu_item req; 
	
	virtual task body();
			`uvm_info("RANDOM SEQUENTION", "START" ,UVM_MEDIUM)
			repeat (50000)
				begin
					`uvm_do(req);
				end
				`uvm_info("SIMULATION RESULT:PASSED","SIMULATION RESULT:PASSED", UVM_MEDIUM)	
	endtask : body

endclass : kg_alu_random_sequence

class kg_alu_minmax_sequence extends kg_alu_base_sequence;

	// Add local random fields and constraints here

	`uvm_object_utils(kg_alu_minmax_sequence)

	function new(string name="kg_alu_random_sequence");
		super.new(name);
	endfunction : new
	
	kg_alu_item req; 
	
	virtual task body();
					`uvm_create(req)
        			 `uvm_info("MINMAX SEQUENTION", "START" ,UVM_MEDIUM)
        			  repeat (50000) begin
            			`uvm_rand_send_with(req,{ A dist {32'd0:=1, 32'hFFFF_FFFF:=1};
                      	B dist {32'd0:=1, 32'hFFFF_FFFF:=1};
	   				  	gen_function == GEN_NORMAL_OPERATION;} )
        			  end
				`uvm_info("SIMULATION RESULT:PASSED","SIMULATION RESULT:PASSED", UVM_MEDIUM)	
	endtask : body

endclass : kg_alu_minmax_sequence

`endif // IFNDEF_GUARD_kg_alu_seq_lib
