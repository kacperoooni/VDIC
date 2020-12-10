class HLV_test extends uvm_test;
	`uvm_component_utils(HLV_test)
	
	env env_h;
	/*
	function void build_phase(uvm_phase phase);
		env_h = env::type_id::create("env_h",this);
		random_tester::type_id::set_type_override(HLV_tester::get_type());
	endfunction : build_phase
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new	
	
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		uvm_top.print_topology();
	endfunction
	*/
	function void build_phase(uvm_phase phase);
		env_h = env::type_id::create("env_h",this);
		command_transaction::type_id::set_type_override(HLV_transaction::get_type());
	endfunction : build_phase
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new	
	
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		uvm_top.print_topology();
	endfunction
	
endclass	