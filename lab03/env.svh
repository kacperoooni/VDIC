class env extends uvm_env;
	`uvm_component_utils(ens)
	base_tester tester_h;
	
	coverage coverage_h;
	scoreboard scoreboard_h;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new	
	
	
	function void build_phase(uvm_phase phase);
		tester_h = base_tester::type_id::create("tester.h", this);
		coverage_h = base_tester::type_id::create("coverage.h", this);
		scoreboard_h = base_tester::type_id::create("scoreboard.h", this);
	endfunction : build_phase
endclass : env	