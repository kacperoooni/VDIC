class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor)
    
	virtual alu_bfm bfm;
    uvm_analysis_port #(command_transaction) ap;
	
	function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction
	
    function void build_phase(uvm_phase phase);

        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
	        begin
            	`uvm_fatal("COMMAND MONITOR", "Failed to get BFM");
        	end
        bfm.command_monitor_h = this;
        ap = new("ap",this);
    endfunction : build_phase

    function void write_to_monitor(bit [98:0] data_to_send, bit reset_now);
	    command_transaction cmd;
	    cmd    = new("cmd");
	    cmd.data_to_send = data_to_send;
	    cmd.reset_now = reset_now;
 	    ap.write(cmd);
    endfunction

    

endclass : command_monitor

