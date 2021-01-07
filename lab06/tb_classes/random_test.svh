
class random_test extends alu_base_test;
   `uvm_component_utils(random_test)
   
   random_sequence rand_seq;

   task run_phase(uvm_phase phase);
      rand_seq = new("rand_seq");
      phase.raise_objection(this);
      rand_seq.start(sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase


   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

endclass