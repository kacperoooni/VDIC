/******************************************************************************
* DVT CODE TEMPLATE: base test
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_base_test
`define IFNDEF_GUARD_kg_alu_base_test

class kg_alu_base_test extends uvm_test;
	
	// Env instance
	kg_alu_env m_env;

	// Table printer instance(optional)
	uvm_table_printer printer;

	`uvm_component_utils(kg_alu_base_test)

	function new(string name = "kg_alu_base_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Create the env
		m_env = kg_alu_env::type_id::create("m_env", this);

		// Create a specific depth printer for printing the created topology
		printer = new();
		printer.knobs.depth = 3;
	endfunction : build_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		// Print the test topology
		`uvm_info(get_type_name(), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
	endfunction : end_of_elaboration_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		// HINT Here you can set the drain-time if desired
		 phase.phase_done.set_drain_time(this, 100ns);
	endtask : run_phase

endclass : kg_alu_base_test

`endif // IFNDEF_GUARD_kg_alu_base_test
