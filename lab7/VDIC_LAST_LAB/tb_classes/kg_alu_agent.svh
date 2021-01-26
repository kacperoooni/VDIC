/******************************************************************************
* DVT CODE TEMPLATE: agent
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_agent
`define IFNDEF_GUARD_kg_alu_agent

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_agent
//
//------------------------------------------------------------------------------

class kg_alu_agent extends uvm_agent;

	// Configuration object
	protected kg_alu_config_obj m_config_obj;
	
	kg_alu_driver m_driver;
	kg_alu_sequencer m_sequencer;
	kg_alu_command_monitor m_command_monitor;
	kg_alu_result_monitor m_result_monitor;
	kg_alu_coverage_collector m_coverage_collector;
	kg_alu_scoreboard m_scoreboard;
	

	`uvm_component_utils(kg_alu_agent)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Get the configuration object
		if(!uvm_config_db#(kg_alu_config_obj)::get(this, "", "m_config_obj", m_config_obj))
			`uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
		// Propagate the configuration object to monitor
		uvm_config_db#(kg_alu_config_obj)::set(this, "m_command_monitor", "m_config_obj", m_config_obj);
		uvm_config_db#(kg_alu_config_obj)::set(this, "m_result_monitor", "m_config_obj", m_config_obj);
		// Create the monitor
		m_command_monitor = kg_alu_command_monitor::type_id::create("m_command_monitor", this);
		m_result_monitor = kg_alu_result_monitor::type_id::create("m_result_monitor", this);
		m_scoreboard = kg_alu_scoreboard::type_id::create("m_scoreboard", this);
		if(m_config_obj.m_coverage_enable) begin
			m_coverage_collector = kg_alu_coverage_collector::type_id::create("m_coverage_collector", this);
		end

		if(m_config_obj.m_is_active == UVM_ACTIVE) begin
			// Propagate the configuration object to driver
			uvm_config_db#(kg_alu_config_obj)::set(this, "m_driver", "m_config_obj", m_config_obj);
			// Create the driver
			m_driver = kg_alu_driver::type_id::create("m_driver", this);

			// Create the sequencer
			m_sequencer = kg_alu_sequencer::type_id::create("m_sequencer", this);
		end
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		if(m_config_obj.m_coverage_enable) begin
			m_command_monitor.m_collected_item_port.connect(m_coverage_collector.m_monitor_port);
		end
			m_result_monitor.m_collected_item_port.connect(m_scoreboard.m_monitor_port);
			m_command_monitor.m_collected_item_port.connect(m_scoreboard.command_it.analysis_export);
		
		
		if(m_config_obj.m_is_active == UVM_ACTIVE) begin
			m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
		end
	endfunction : connect_phase

endclass : kg_alu_agent

`endif // IFNDEF_GUARD_kg_alu_agent
