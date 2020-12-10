class driver extends uvm_component;
    `uvm_component_utils(driver)

    virtual alu_bfm bfm;
    uvm_get_port #(random_command) command_port;

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm",bfm))
			$fatal(1,"Failed to get BFM");
        command_port = new("command_port",this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
	    random_command command;
        bfm.init_alu();
	    forever begin
		    command_port.get(command);
		    if(command.reset_now == 1)
			    begin
			    	bfm.reset_alu();
				end
		    else
			    begin
			    	bfm.send_data(command.data_to_send);
				end    
		    #1000;
	    end
    endtask : run_phase

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : driver