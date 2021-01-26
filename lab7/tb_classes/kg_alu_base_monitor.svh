/******************************************************************************
* DVT CODE TEMPLATE: monitor
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_monitor
`define IFNDEF_GUARD_kg_alu_monitor

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_monitor
//
//------------------------------------------------------------------------------

class kg_alu_base_monitor extends uvm_monitor;

	// The virtual interface to HDL signals.
	protected virtual kg_alu_if m_kg_alu_vif;

	// Configuration object
	protected kg_alu_config_obj m_config_obj;

	// Collected item
	protected kg_alu_item m_collected_item;

	// Collected item is broadcast on this port
	uvm_analysis_port #(kg_alu_item) m_collected_item_port;

	`uvm_component_utils(kg_alu_base_monitor)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Get the interface
		if(!uvm_config_db#(virtual kg_alu_if)::get(this, "", "m_kg_alu_vif", m_kg_alu_vif))
			`uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".m_kg_alu_vif"})

		// Get the configuration object
		if(!uvm_config_db#(kg_alu_config_obj)::get(this, "", "m_config_obj", m_config_obj))
			`uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".m_config_obj"})
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		process main_thread; // main thread
		process rst_mon_thread; // reset monitor thread

		// Start monitoring only after an initial reset pulse
		@(negedge m_kg_alu_vif.rst_n)
			do @(posedge m_kg_alu_vif.clk);
			while(m_kg_alu_vif.rst_n==1);

		// Start monitoring
		forever begin
			fork
				// Start the monitoring thread
				begin
					main_thread=process::self();
					collect_items();
				end
				// Monitor the reset signal
				begin
					rst_mon_thread = process::self();
					@(posedge m_kg_alu_vif.rst_n) begin
						// Interrupt current item at reset
						reset_monitor();
						if(main_thread) main_thread.kill();
					end
				end
			join_any

			if (rst_mon_thread) rst_mon_thread.kill();
		end
	endtask : run_phase

	virtual protected task collect_items();
		
	endtask : collect_items

	virtual protected function void perform_item_checks();
		//Perform item checks here
	endfunction : perform_item_checks

	virtual protected function void reset_monitor();
		//Reset monitor specific state variables (e.g. counters, flags, buffers, queues, etc.)
	endfunction : reset_monitor

endclass : kg_alu_base_monitor

`endif // IFNDEF_GUARD_kg_alu_monitor
