class result_transaction extends uvm_transaction;
    `uvm_object_utils(result_transaction)

   bit[54:0] read_data_output; 
   bit[4:0] read_flags; 
   bit[2:0] read_crc_output; 
   bit[2:0] read_err_flags;
   bit read_parity_bit;
   bit signed[31:0] read_number_output;

   function new(string name = "");
      super.new(name);
   endfunction : new

   virtual function void do_copy(uvm_object rhs);
      result_transaction copied_transaction_h;
      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");
      super.do_copy(rhs);
      assert($cast(copied_transaction_h,rhs)) else
        $fatal(1,"Failed cast in do_copy");
      read_data_output = copied_transaction_h.read_data_output;
      read_flags = copied_transaction_h.read_flags;
      read_crc_output = copied_transaction_h.read_crc_output;
      read_err_flags = copied_transaction_h.read_err_flags;
      read_parity_bit = copied_transaction_h.read_parity_bit;
      read_number_output = copied_transaction_h.read_number_output;
   endfunction : do_copy

   virtual function string convert2string();
      string s;
	  s = $sformatf("result: %d read flags: %b read_err_flags: %b read_parity_bit: %b",read_data_output,read_flags,read_err_flags,read_parity_bit);
      return s;
   endfunction : convert2string

   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      result_transaction RHS;
      bit    same;
      assert(rhs != null) else
        $fatal(1,"Tried to copare null transaction");

      same = super.do_compare(rhs, comparer);

      $cast(RHS, rhs);
      same = ((read_data_output == RHS.read_data_output) && 
	      		(same == 1) &&
	      		(read_flags == RHS.read_flags) &&
	      		(read_crc_output == RHS.read_crc_output) &&
	      		(read_err_flags == RHS.read_err_flags) &&
	      		(read_parity_bit == RHS.read_parity_bit) &&
	      		(read_number_output == RHS.read_number_output));
      return same;
   endfunction : do_compare

endclass : result_transaction