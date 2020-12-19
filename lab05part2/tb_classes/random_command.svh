class random_command extends uvm_transaction;
   `uvm_object_utils(random_command)
   rand bit signed[31:0]     A;
   rand bit signed[31:0]     B;
   rand operation_t          op_code;
   rand function_t 			 gen_function;
   bit [98:0]                data_to_send;
   bit                       reset_now;

   constraint data { //A dist {32'd0:=100000, 32'hFFFF_FFFF:=100000, [32'h1:32'hFFFF_FFFF]:/100000};
                     //B dist {32'd0:=100000, 32'hFFFF_FFFF:=100000, [32'h1:32'hFFFF_FFFF]:/100000};
	   				 op_code dist {sub_op :=1,add_op :=1,or_op :=1,and_op :=1,no_op :=0};
	   				 gen_function dist {GEN_NORMAL_OPERATION :=8, GEN_CRC_ERROR :=1, GEN_BYTE_ERROR := 1,GEN_RESET :=1,GEN_UNKNOWN_OP :=1};
	   			   } 
   
   

   virtual function void do_copy(uvm_object rhs);
      random_command copied_transaction_h;

      if(rhs == null) 
        `uvm_fatal("COMMAND TRANSACTION", "Tried to copy from a null pointer")
      
      super.do_copy(rhs); // copy all parent class data

      if(!$cast(copied_transaction_h,rhs))
        `uvm_fatal("COMMAND TRANSACTION", "Tried to copy wrong type.")

      A = copied_transaction_h.A;
      B = copied_transaction_h.B;
      op_code = copied_transaction_h.op_code;
      gen_function = copied_transaction_h.gen_function;
      data_to_send = copied_transaction_h.data_to_send;
      reset_now = copied_transaction_h.reset_now;
   endfunction : do_copy

   virtual function random_command clone_me();
      random_command clone;
      uvm_object tmp;

      tmp = this.clone();
      $cast(clone, tmp);
      return clone;
   endfunction : clone_me
   

   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      random_command compared_transaction_h;
      bit   same;
      
      if (rhs==null) `uvm_fatal("RANDOM TRANSACTION", 
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(compared_transaction_h,rhs))
        same = 0;
      else
        same = super.do_compare(rhs, comparer) && 
               (compared_transaction_h.B == B) &&
               (compared_transaction_h.B == B) &&
               (compared_transaction_h.op_code == op_code) &&
               (compared_transaction_h.gen_function == gen_function) &&
               (compared_transaction_h.reset_now == reset_now) &&
               (compared_transaction_h.data_to_send == data_to_send);
               
      return same;
   endfunction : do_compare


   virtual function string convert2string();
      string s;
      s = $sformatf("A: %d  B: %d op: %s func: %s",
                        A, B, op_code.name(), gen_function.name());
      return s;
   endfunction : convert2string

   function new (string name = "");
      super.new(name);
   endfunction : new

endclass