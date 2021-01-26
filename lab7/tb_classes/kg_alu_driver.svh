/******************************************************************************
* DVT CODE TEMPLATE: driver
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_driver
`define IFNDEF_GUARD_kg_alu_driver

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_driver
//
//------------------------------------------------------------------------------

class kg_alu_driver extends uvm_driver #(kg_alu_item);

	// The virtual interface to HDL signals.
	protected virtual kg_alu_if m_kg_alu_vif;

	// Configuration object
	protected kg_alu_config_obj m_config_obj;

	`uvm_component_utils(kg_alu_driver)

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
			`uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		// Driving should be triggered by an initial reset pulse
		
		@(negedge m_kg_alu_vif.rst_n)
			do @(posedge m_kg_alu_vif.clk);
			while(m_kg_alu_vif.rst_n==1);
		// Start driving
		get_and_drive();
	endtask : run_phase

	virtual protected task get_and_drive();
		process main_thread; // main thread
		process rst_mon_thread; // reset monitor thread

		forever begin
			// Don't drive during reset
			while(m_kg_alu_vif.rst_n==1) @(posedge m_kg_alu_vif.clk);
			// Get the next item from the sequencer
			seq_item_port.get_next_item(req);
			$cast(rsp, req.clone());
			rsp.set_id_info(req);
			// Drive current transaction
			fork
				// Drive the transaction
				begin
					main_thread=process::self();
					#1000;
					`uvm_info(get_type_name(), $sformatf("kg_alu_driver %0d start driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)
					drive_item(rsp);
					`uvm_info(get_type_name(), $sformatf("kg_alu_driver %0d done driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)
					if (rst_mon_thread) rst_mon_thread.kill();
				end
				// Monitor the reset signal
				begin
					rst_mon_thread = process::self();
					@(negedge m_kg_alu_vif.rst_n) begin
						// Interrupt current transaction at reset
						if(main_thread) main_thread.kill();
						// Do reset
						reset_signals();
						reset_driver();
					end
				end
			join_any

			// Send item_done and a response to the sequencer
			seq_item_port.item_done();
		end
	endtask : get_and_drive

	virtual protected task reset_signals();
		// Reset the signals to their default values
	endtask : reset_signals

	virtual protected task reset_driver();
		// Reset driver specific state variables (e.g. counters, flags, buffers, queues, etc.)
	endtask : reset_driver

	virtual protected task drive_item(kg_alu_item item);
		m_kg_alu_vif.send_op(item.A, item.B, item.op_code, item.gen_function);
	endtask : drive_item

endclass : kg_alu_driver

`endif // IFNDEF_GUARD_kg_alu_driver
