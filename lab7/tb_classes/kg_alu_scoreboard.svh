`ifndef IFNDEF_GUARD_kg_alu_scoreboard
`define IFNDEF_GUARD_kg_alu_scoreboard


class kg_alu_scoreboard extends uvm_component;
	
	// Configuration object
	protected kg_alu_config_obj m_config_obj;

	
	
	// Item collected from the monitor
	protected kg_alu_result_item m_collected_item;

	// Using suffix to handle more ports
	`uvm_analysis_imp_decl(_collected_item)

	// Connection to the monitor
	uvm_analysis_imp_collected_item#(kg_alu_result_item, kg_alu_scoreboard) m_monitor_port;
	uvm_tlm_analysis_fifo #(kg_alu_item) command_it;
	
	`uvm_component_utils(kg_alu_scoreboard)
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction	: new
	
	function void build_phase(uvm_phase phase);  
		super.build_phase(phase);
		command_it = new ("command_it", this);
		m_monitor_port = new("m_monitor_port",this);

		// Get the configuration object
		if(!uvm_config_db#(kg_alu_config_obj)::get(this, "", "m_config_obj", m_config_obj))
			`uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
			
	    endfunction : build_phase	
	
	protected function bit Check_parity(bit[2:0] err_flags_in);
		bit[6:0] data;
		bit parity_bit;
		byte i;
		parity_bit = 0;
		data = {1'b1,err_flags_in,err_flags_in};
		for(i = 0; i < 7; i++)
			parity_bit = parity_bit ^ data[i];
		return parity_bit;
	endfunction	
	
	function void write_collected_item(kg_alu_result_item t);
		kg_alu_item cmd;
		if (!command_it.try_get(cmd))
	                $fatal(1, "Missing data in input fifo");
				check_result(cmd.data_to_send,		
							t.read_data_output,
							t.read_number_output,
							t.read_flags, 
							t.read_crc_output, 
							t.read_err_flags, 
							t.read_parity_bit
					);	
	endfunction
	
	
	 
	 
	
								
	function void check_result(	input bit[98:0] data_read_input,
								input bit[54:0] read_data_output,
								input bit signed[31:0] read_number_output,
								input bit[4:0] read_flags, 
								input bit[2:0] read_crc_output, 
								input bit[2:0] read_err_flags, 
								input bit read_parity_bit
								);
		bit signed[31:0] predicted_result;
	    bit[2:0] predicted_CRC_output;
	    bit[3:0] predicted_flags;
	    bit[3:0] predicted_CRC_input;
	    bit[2:0] predicted_err_flags;
	    bit predicted_parity_bit;
	    bit[2:0] output_type_rec;
		bit signed[31:0] A_read,B_read;
		operation_t read_op_code;
		output_type_rec = read_data_output[54:52];
		//CHECK INPUT BYTES NUMBER///////////////////////////
		check_err_flags(data_read_input, predicted_err_flags);
		//IF OUTPUT MESSAGE WAS DATA////////////////////////
		if(output_type_rec[2:1] == 2'b00 )
			begin
				{B_read,A_read} = {data_read_input[96:89],data_read_input[85:78],data_read_input[74:67],data_read_input[63:56],data_read_input[52:45],data_read_input[41:34],data_read_input[30:23],data_read_input[19:12]};
				check_art_flags(data_read_input, predicted_flags, predicted_result, read_op_code);
			    predicted_CRC_output = calc_CRC_output(predicted_result, predicted_flags);
			    if((read_op_code == add_op)|(read_op_code == and_op)|(read_op_code == or_op)|(read_op_code == sub_op)) //CHECK IF OPCODE IS CORRECT
				      if ((predicted_result != read_number_output) | (predicted_flags != read_flags) | (predicted_CRC_output != read_crc_output))
					      begin
					         `uvm_fatal("SIMULATION RESULT: FAILED", $sformatf("FAILED: A: %d  B: %d  op: %s result: %0d predicted_result: %0d flags: %0b predicted_flags: %0b output crc: %0h predicted output crc: %0h",A_read,B_read,
					                 read_op_code.name(), read_number_output, predicted_result, read_flags, predicted_flags, read_crc_output, predicted_CRC_output));
//						      $stop;
//						      $error ("SIMULATION RESULT: FAILED");
//						     $finish; 
					      end
			end		
		//IF OUTPUT MESSAGE WAS ONLY CTL///////////////////////////////////////
		else if(output_type_rec == 3'b011)
			begin
			  	predicted_parity_bit = Check_parity(predicted_err_flags); //CALCULATING PARITY BIT
				if ((predicted_err_flags != read_err_flags)|(predicted_parity_bit != read_parity_bit)) 
					begin
			  		  `uvm_fatal("SIMULATION RESULT: FAILED",$sformatf("FAILED: predicted_err_flags: %0b read_err_flags: %0b, predicted_parity_bit: %0b read_parity_bit: %0b",
			      	         predicted_err_flags, read_err_flags, predicted_parity_bit, read_parity_bit));
//						$stop;
//						$error ("SIMULATION RESULT: FAILED");
//				   	$finish; 
					end
			end
		endfunction
endclass

`endif // IFNDEF_GUARD_kg_alu_coverage_collector