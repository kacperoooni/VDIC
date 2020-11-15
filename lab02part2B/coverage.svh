class coverage;
	virtual alu_bfm bfm_cov;





function bit[3:0] calc_CRC_input(int B, int A, bit[2:0] op_code);
	bit[67:0] data_in;
	static bit[3:0] lfsr_q = 0;
	bit[3:0] lfsr_c;
	data_in = {B,A,1'b1,op_code};
	lfsr_c[0] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[45] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[66];
    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[42] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63] ^ data_in[65] ^ data_in[66] ^ data_in[67];
    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[64] ^ data_in[66] ^ data_in[67];
    lfsr_c[3] = lfsr_q[1] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[59] ^ data_in[62] ^ data_in[63] ^ data_in[65] ^ data_in[67];
	return lfsr_c; //CRC
endfunction	
	
	
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

function new (virtual alu_bfm bfm);
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
	bfm_cov = bfm;
endfunction
		
task execute();
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
				read_iterator_input_cg = 99;
				@(negedge bfm_cov.sin);
				repeat(99)
					begin
						@(posedge bfm_cov.clk);
						read_iterator_input_cg--;
						data_read_input_cg[read_iterator_input_cg] = bfm_cov.sin;
					end	
		   predicted_err_flags_cg = 0;
		   //CHECK INPUT BYTES NUMBER///////////////////////////
		   if((data_read_input_cg[10] == 0 ) & (data_read_input_cg[9] == 1)) // OK NUMBER
			   begin
				   {B_read_cg,A_read_cg,dummy_cg,read_op_code_cg,read_crc_input_cg} = {data_read_input_cg[96:89],data_read_input_cg[85:78],data_read_input_cg[74:67],data_read_input_cg[63:56],data_read_input_cg[52:45],data_read_input_cg[41:34],data_read_input_cg[30:23],data_read_input_cg[19:12],data_read_input_cg[8:1]};
				   read_op_code_cg_prv = read_op_code_cg;
			   		predicted_CRC_input = calc_CRC_input(B_read_cg, A_read_cg, read_op_code_cg);
				   	if(read_crc_input_cg != predicted_CRC_input) predicted_err_flags_cg[1] = 1; //WRONG INPU CRC CODE
				   	else if((read_op_code_cg != add_op)&(read_op_code_cg!= and_op)&(read_op_code_cg != or_op)&(read_op_code_cg != sub_op)) predicted_err_flags_cg[0] = 1; //WRONG OP CODE
			   end
		   else
		   	 predicted_err_flags_cg[2] = 1; //WRONG NUMBER
		   //IF OUTPUT MESSAGE WAS DATA////////////////////////
		   if(predicted_err_flags_cg == 3'b000)
			   begin
			      case (read_op_code_cg)
			        and_op:predicted_result = B_read_cg & A_read_cg;			        		
			        or_op: predicted_result = B_read_cg | A_read_cg;
			        add_op:
			        	begin
				        	{c,predicted_result} = $unsigned(B_read_cg) + $unsigned(A_read_cg);
				        	if((B_read_cg >= 0) & (A_read_cg >= 0) & (predicted_result < 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        	else if((B_read_cg < 0) & (A_read_cg < 0) & (predicted_result > 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        end
			        sub_op:
			        	begin
							{c,predicted_result} = $unsigned(B_read_cg) - $unsigned(A_read_cg);
				        	if((B_read_cg >= 0) & (A_read_cg < 0) & (predicted_result < 0)) predicted_flags_cg[2] = 1; //overflow flag prediction
				        	else if((B_read_cg < 0) & (A_read_cg >= 0) & (predicted_result >= 0)) predicted_flags_cg[2] = 1; //overflow flag prediction      	
				        end	
			      endcase 
			      if(c == 1) predicted_flags_cg[3] = 1;
			      if(predicted_result == 0) predicted_flags_cg[1] = 1; //zero flag prediction
			      if(predicted_result < 0) predicted_flags_cg[0] = 1; //negative flag prediction
			      
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
				predicted_flags_cg = 0; // RESET FLAGS
				c = 0;// RESET CARRY
			end
	end
endtask		

task execute_2();
	begin
		@(negedge bfm_cov.rst_n)
		was_reset <= 1;
	end	
endtask
endclass
	