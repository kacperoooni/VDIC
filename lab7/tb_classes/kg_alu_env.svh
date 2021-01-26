/******************************************************************************
* DVT CODE TEMPLATE: env
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_env
`define IFNDEF_GUARD_kg_alu_env

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_env
//
//------------------------------------------------------------------------------

class kg_alu_env extends uvm_env;
	
	// Components of the environment
	kg_alu_agent m_kg_alu_agent;

	`uvm_component_utils(kg_alu_env)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		begin
			// Create the configuration object if it has not been set
			kg_alu_config_obj config_obj;
			if(!uvm_config_db#(kg_alu_config_obj)::get(this, "", "m_config_obj", config_obj)) begin
				config_obj = kg_alu_config_obj::type_id::create("m_config_obj", this);
				uvm_config_db#(kg_alu_config_obj)::set(this, {"m_kg_alu_agent","*"}, "m_config_obj", config_obj);
			end

			// Create the agent
			m_kg_alu_agent = kg_alu_agent::type_id::create("m_kg_alu_agent", this);
		end

	endfunction : build_phase

endclass : kg_alu_env

`endif // IFNDEF_GUARD_kg_alu_env
