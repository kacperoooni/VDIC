class HLV_transaction extends command_transaction;
    `uvm_object_utils(HLV_transaction)

    constraint data { A dist {32'd0:=1, 32'hFFFF_FFFF:=1};
                      B dist {32'd0:=1, 32'hFFFF_FFFF:=1};
	   				  gen_function == GEN_NORMAL_OPERATION;} 

    function new(string name="");
        super.new(name);
    endfunction

endclass 