class driver extends uvm_driver #(sequence_item);
    `uvm_component_utils(driver)

    virtual alu_bfm bfm;

	function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
    endfunction : build_phase

    task run_phase(uvm_phase phase);
	    sequence_item seq_it;
        bfm.init_alu();
	    forever begin
		    seq_item_port.get_next_item(seq_it);
            bfm.send_op(seq_it.A, seq_it.B, seq_it.op_code, seq_it.gen_function);
            seq_item_port.item_done();  
		    #1000;
	    end
    endtask : run_phase

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : driver