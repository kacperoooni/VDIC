class minmax_command extends random_command;
    `uvm_object_utils(minmax_command)

    constraint data { A dist {32'd0:=1, 32'hFFFF_FFFF:=1};
                      B dist {32'd0:=1, 32'hFFFF_FFFF:=1};
	   				  gen_function == GEN_NORMAL_OPERATION;} 

    function new(string name="");
        super.new(name);
    endfunction

endclass 