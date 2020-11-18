virtual class base_tester extends uvm_component;
	`uvm_component_utils(base_tester)
	
	virtual alu_bfm bfm_tester;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm",bfm_tester))
			$fatal(1,"Failed to get BFM");
	endfunction
	
	pure virtual function operation_t get_op();
	pure virtual function function_t get_function();
	pure virtual function bit [43:0] DATA(int data);
	pure virtual function bit [10:0] CTL(byte data);
	
	task run_phase(uvm_phase phase);
		$error("You called base tester");
	endtask
	
endclass
	
	
	