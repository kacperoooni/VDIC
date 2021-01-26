/******************************************************************************
* DVT CODE TEMPLATE: testbench top module
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

module alu_tb_top;

	// Import the UVM package
	import uvm_pkg::*;

	// Import the UVC that we have implemented
	import kg_alu_pkg::*;

	// Import all the needed packages
	

	// Clock and reset signals
	wire rst_n_negated;
	assign rst_n_negated = ~vif.rst_n;
	// The interface
	kg_alu_if vif();


	mtm_Alu dut(
		.clk(vif.clk),
		.rst_n(rst_n_negated),
		.sin(vif.sin),
		.sout(vif.sout)
	);

	initial begin
		// Propagate the interface to all the components that need it
		uvm_config_db#(virtual kg_alu_if)::set(uvm_root::get(), "*", "m_kg_alu_vif", vif);
		// Start the test
		run_test();
	end

	// Generate clock
	
	
	
endmodule
