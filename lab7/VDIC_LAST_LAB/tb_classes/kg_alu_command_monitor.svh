/******************************************************************************
* DVT CODE TEMPLATE: monitor
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_command_monitor
`define IFNDEF_GUARD_kg_alu_command_monitor

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_command_monitor
//
//------------------------------------------------------------------------------

class kg_alu_command_monitor extends kg_alu_base_monitor;
	
	`uvm_component_utils(kg_alu_command_monitor)
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
		// Allocate collected_item.
		m_collected_item = kg_alu_item::type_id::create("m_collected_item", this);

		// Allocate collected_item_port.
		m_collected_item_port = new("m_collected_item_port", this);
	endfunction : new

	bit [98:0] data_to_send; 
	bit reset_now;

	virtual protected task collect_items();
		forever begin
			m_kg_alu_vif.input_deserializer(data_to_send);
			m_collected_item.data_to_send = data_to_send;
			m_collected_item.reset_now = reset_now;
			`uvm_info(get_full_name(), $sformatf("Item collected :\n%s", m_collected_item.sprint()), UVM_HIGH);
			m_collected_item_port.write(m_collected_item);
			reset_now = 0;
		end
	endtask : collect_items
	
	virtual protected function void reset_monitor();
		reset_now = 1;
	endfunction : reset_monitor
	
endclass : kg_alu_command_monitor

`endif // IFNDEF_GUARD_kg_alu_command_monitor
