class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor)
    
	virtual alu_bfm bfm;
    uvm_analysis_port #(sequence_item) ap;
	
	function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("COMMAND MONITOR", "Failed to get BFM")
        ap = new("ap",this);
    endfunction : build_phase
    
    function void connect_phase(uvm_phase phase);
        bfm.command_monitor_h = this;
    endfunction : connect_phase
    
    function void write_to_monitor(bit [98:0] data_to_send, bit reset_now);
		    sequence_item seq_it;
		    seq_it    = new("seq_it");
		    seq_it.data_to_send = data_to_send;
		    seq_it.reset_now = reset_now;
	 	    ap.write(seq_it);
	    
    endfunction

    

endclass : command_monitor

