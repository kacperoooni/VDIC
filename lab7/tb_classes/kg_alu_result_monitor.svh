/******************************************************************************
* DVT CODE TEMPLATE: monitor
* Created by kgaweda on Jan 25, 2021
* uvc_company = kg, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_kg_alu_result_monitor
`define IFNDEF_GUARD_kg_alu_result_monitor

//------------------------------------------------------------------------------
//
// CLASS: kg_alu_command_monitor
//
//------------------------------------------------------------------------------

class kg_alu_result_monitor extends kg_alu_base_monitor;
	
	`uvm_component_utils(kg_alu_result_monitor)
	
	// Collected item
	protected kg_alu_result_item m_collected_item;
	
	uvm_analysis_port #(kg_alu_result_item) m_collected_item_port;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
		// Allocate collected_item.
		m_collected_item = kg_alu_result_item::type_id::create("m_collected_item", this);

		// Allocate collected_item_port.
		m_collected_item_port = new("m_collected_item_port", this);
		
	endfunction : new



	virtual protected task collect_items();
		forever begin
			m_kg_alu_vif.output_deserializer(m_collected_item.read_data_output,m_collected_item.read_number_output, m_collected_item.read_flags, m_collected_item.read_crc_output, m_collected_item.read_err_flags, m_collected_item.read_parity_bit);
			`uvm_info(get_full_name(), $sformatf("Item collected result :\n%s", m_collected_item.sprint()), UVM_HIGH);
			m_collected_item_port.write(m_collected_item);
		end
	endtask : collect_items
	
	
endclass : kg_alu_result_monitor

`endif // IFNDEF_GUARD_kg_alu_result_monitor

