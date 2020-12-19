class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)

    virtual alu_bfm bfm;
    uvm_analysis_port #(result_transaction) ap;

    function void write_to_monitor(bit[54:0] read_data_output, 
								   bit signed[31:0] read_number_output,
								   bit[4:0] read_flags,
								   bit[2:0] read_crc_output,
								   bit[2:0] read_err_flags,
								   bit read_parity_bit);
	    result_transaction result;
	    result    = new("result");
	    result.read_data_output = read_data_output; 
	    result.read_number_output = read_number_output;
	    result.read_flags = read_flags; 
	    result.read_crc_output = read_crc_output; 
	    result.read_err_flags = read_err_flags;
	    result.read_parity_bit = read_parity_bit;
        ap.write(result);
    endfunction : write_to_monitor

    function void build_phase(uvm_phase phase);
        alu_agent_config alu_agent_config_h;
		
        if(!uvm_config_db #(alu_agent_config)::get(this, "","config", alu_agent_config_h))
            `uvm_fatal("RESULT MONITOR", "Failed to get CONFIG");

        alu_agent_config_h.bfm.result_monitor_h = this;
		
        ap = new("ap",this);
    endfunction : build_phase

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : result_monitor





