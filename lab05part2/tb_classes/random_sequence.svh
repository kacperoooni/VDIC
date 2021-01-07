


class random_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(random_sequence)

    sequence_item seq_it;

    function new(string name = "");
        super.new(name);
    endfunction : new

    task body();
        `uvm_info("RANDOM SEQUENTION", "START" ,UVM_MEDIUM)
        repeat (50000) begin
            `uvm_do(seq_it);
        end
    endtask : body
endclass