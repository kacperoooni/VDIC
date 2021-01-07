
class minmax_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(minmax_sequence)

    sequence_item seq_it;

    function new(string name = "");
        super.new(name);
    endfunction : new

    task body();
	    `uvm_create(seq_it)
        `uvm_info("MINMAX SEQUENTION", "START" ,UVM_MEDIUM)
        repeat (50000) begin
            `uvm_rand_send_with(seq_it,{ A dist {32'd0:=1, 32'hFFFF_FFFF:=1};
                      B dist {32'd0:=1, 32'hFFFF_FFFF:=1};
	   				  gen_function == GEN_NORMAL_OPERATION;} )
        end
    endtask : body
endclass