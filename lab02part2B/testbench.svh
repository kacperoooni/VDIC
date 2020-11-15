class testbench;
	virtual alu_bfm main_bfm;
	
	scoreboard scoreboard_h;
	tester tester_h;
	coverage coverage_h;
	
	function new(virtual alu_bfm bfm);
		main_bfm = bfm;
	endfunction	
	
	
	task execute();
		scoreboard_h = new(main_bfm);
		coverage_h = new(main_bfm);
		tester_h = new(main_bfm);
		fork
			tester_h.execute();
			coverage_h.execute();
			scoreboard_h.execute();
		join_none	
	endtask	
endclass