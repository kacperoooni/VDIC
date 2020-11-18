class coverage;
	virtual alu_bfm bfm_cov;

///////////////COVERAGE DESERIALIZER VARIABLES////////////////////////////////////////
bit[7:0] read_iterator_input_cg;
bit[3:0] read_crc_input_cg;
bit[98:0] data_read_input_cg;
bit signed[31:0] A_read_cg,B_read_cg;
bit dummy_cg;
operation_t read_op_code_cg,read_op_code_cg_prv;
bit was_reset;
bit[3:0] predicted_flags_cg, predicted_flags_cg_prv; 
bit[2:0] predicted_err_flags_cg,predicted_err_flags_cg_prv; 
bit signed [31:0] predicted_result_cg;

////////////COVERAGE COVERGROUPS///////////////////////////////////////////////////////////////
covergroup cg_op_all;
      coverpoint read_op_code_cg {
         // #A1 test all operations
         bins A1_all_ops[] = {and_op,or_op,add_op,sub_op};
      }
endgroup

covergroup cg_op_ar;
      coverpoint read_op_code_cg {
         // #A1 test all operations
         bins A1_all_ops[] = {and_op,or_op,add_op,sub_op};
      }
endgroup

covergroup cg_op_br;
      coverpoint read_op_code_cg_prv {
         // #A1 test all operations
         bins A1_all_ops[] = {and_op,or_op,add_op,sub_op};
      }
endgroup


covergroup cg_op_all_HLV;
      OP: coverpoint read_op_code_cg {
         // #B1 test all operations with highest values
         bins B1_all_ops_HLV[] = {and_op,or_op,add_op,sub_op};
	  }
	  A: coverpoint A_read_cg{
		 bins B1_A_values[] = {-1, 0};
	  } 
	  B: coverpoint B_read_cg{
		 bins B1_B_values[] = {-1, 0};
	  } 
	  cross A,B,OP;
      
endgroup

covergroup cg_err_flags_cov;
      coverpoint predicted_err_flags_cg {
         // #B2 test all error flags
         bins B2_read_err_flags[] = {3'b100,3'b010,3'b001};
      }
endgroup

covergroup cg_err_flags_cov_ar;
      coverpoint predicted_err_flags_cg {
         // #B2 test all error flags
         bins B2_read_err_flags[] = {3'b100,3'b010,3'b001};
      }
endgroup

covergroup cg_err_flags_cov_br;
      coverpoint predicted_err_flags_cg_prv {
         // #B4 test all error flags
         bins B1_read_err_flags[] = {3'b100,3'b010,3'b001};
      }
endgroup

covergroup cg_flags_cov;
      coverpoint predicted_flags_cg {
         //  test all error flags
         bins all_flags[] = {[0:$]};
	     ignore_bins all_flags_ignored = {3,6,7,10,11,14,15};
      }
endgroup

covergroup cg_flags_cov_ar;
      coverpoint predicted_flags_cg {
         //  test all error flags
         bins all_flags[] = {[0:$]};
	     ignore_bins all_flags_ignored = {3,6,7,10,11,14,15};
      }
endgroup

covergroup cg_flags_cov_br;
      coverpoint predicted_flags_cg_prv {
         //  test all flags
         bins all_flags[] = {[0:$]};
	     ignore_bins all_flags_ignored = {3,6,7,10,11,14,15};
      }
endgroup

function new (string name, uvm_component parent);
	begin
		cg_op_all = new();
		cg_op_all.option.name = "A1.Test all operations";
		cg_op_ar = new();
		cg_op_ar.option.name = "A2.Test all operations after reset";
		cg_op_br = new();
		cg_op_br.option.name = "A3.Test reset after all operations";
		cg_err_flags_cov = new();
		cg_err_flags_cov.option.name = "B2.Simulate all error flags";
		cg_err_flags_cov_ar = new();
		cg_err_flags_cov_ar.option.name = "B3.Test all error flags after reset";
		cg_err_flags_cov_br = new();
		cg_err_flags_cov_br.option.name = "B4.Test reset after all error flags";
		cg_flags_cov = new();
		cg_flags_cov.option.name = "B5.Simulate all arithmetic flags";
		cg_flags_cov_ar = new();
		cg_flags_cov_ar.option.name = "B6.Test all arithmetic flags after reset";
		cg_flags_cov_br = new();
		cg_flags_cov_br.option.name = "B7.Test reset after all arithmetic flags ";
		cg_op_all_HLV = new();
		cg_op_all_HLV.option.name = "B1.Simulate all operations with the lowest and highest possible input values (A and B)";
		super.new(name,parent);
	end	
endfunction

function build_phase(uvm_phase phase);
	if(!uvm_config_db #(virtual alu_bfm)::get(null,"*","bfm",bfm_cov))



task run_phase();
	fork
		execute_1();
		execute_2();
	join_none
endtask	


task execute_1();
	begin
		bit c;//carry bit
		bit signed[31:0] predicted_result;
		bit[3:0] predicted_CRC_input;
		forever
			begin
				bfm_cov.input_deserializer(data_read_input_cg);
			   //CHECK INPUT BYTES NUMBER///////////////////////////
			   check_err_flags(data_read_input_cg, predicted_err_flags_cg);
			   if((data_read_input_cg[10] == 0 ) & (data_read_input_cg[9] == 1)) // OK NUMBER
			   	 read_op_code_cg_prv = read_op_code_cg;
			   //IF OUTPUT MESSAGE WAS DATA////////////////////////
			   if(predicted_err_flags_cg == 3'b000)
				   begin
					  check_art_flags(data_read_input_cg, predicted_flags_cg, predicted_result_cg, read_op_code_cg);
					  {B_read_cg,A_read_cg} = {data_read_input_cg[96:89],data_read_input_cg[85:78],data_read_input_cg[74:67],data_read_input_cg[63:56],data_read_input_cg[52:45],data_read_input_cg[41:34],data_read_input_cg[30:23],data_read_input_cg[19:12]};
				      cg_op_all.sample();
				      cg_flags_cov.sample();
				      cg_op_all_HLV.sample();
				      if(was_reset == 1)
					      begin
					      	cg_op_ar.sample();
						    cg_op_br.sample(); 
						    cg_flags_cov_ar.sample(); 
						    cg_flags_cov_br.sample(); 
					      end   
					 read_op_code_cg_prv = read_op_code_cg;
					 predicted_flags_cg_prv = predicted_flags_cg;     
					 predicted_err_flags_cg_prv = 0;
				   end
			   else
				   begin
					  cg_err_flags_cov.sample(); 
				      if(was_reset == 1)
				      	begin
					      	cg_err_flags_cov_br.sample();
					      	cg_err_flags_cov_ar.sample();
				      	end
				      predicted_err_flags_cg_prv = predicted_err_flags_cg;	
				      read_op_code_cg_prv = no_op;
				      predicted_flags_cg_prv = 0;
				   end   	
				   	was_reset = 0;
			end
	end
endtask		

task execute_2();
	forever
		begin
			@(negedge bfm_cov.rst_n)
			was_reset <= 1;
		end	
endtask
endclass
	