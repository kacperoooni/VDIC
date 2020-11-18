class scoreboard extends uvm_component;
	`uvm_component_utils(scoreboard)
	virtual alu_bfm sb_bfm;

function new(string name, uvm_component parent);
	super.new(name,parent);
endfunction	: new

function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(virtual alu_bfm)::get(null,"*","bfm",sb_bfm))
		$fatal(1,"Failed to get BFM");
endfunction		

protected function bit Check_parity(bit[2:0] err_flags_in);
	bit[6:0] data;
	bit parity_bit;
	byte i;
	parity_bit = 0;
	data = {1'b1,err_flags_in,err_flags_in};
	for(i = 0; i < 7; i++)
		parity_bit = parity_bit ^ data[i];
	return parity_bit;
endfunction	

task run_phase(uvm_phase phase);
	fork
		execute_1();
		execute_2();
		execute_3();
	join_none	
endtask

		state_deserializer_t state_deserializer;		
		bit[7:0] read_iterator_input;
		bit[98:0] data_read_input,data_read_input_nxt;
		
		bit[7:0] read_iterator_output;	
		bit[4:0] read_flags;
		bit[2:0] read_err_flags;	
		bit[54:0] read_data_output;	
		bit signed[31:0] read_number_output;
		bit[2:0] read_crc_output;	
		bit dummy,read_parity_bit;
  	   
	   bit signed[31:0] predicted_result;
	   bit[2:0] predicted_CRC_output;
	   bit[3:0] predicted_flags;
	   bit[3:0] predicted_CRC_input;
	   bit[2:0] predicted_err_flags;
	   bit predicted_parity_bit;
	   bit[2:0] output_type_rec;
		operation_t read_op_code;
 
 

task execute_1();
	begin
		///////////////SCOREBOARD  INPUT DESERIALIZER //////////////////////////////////////	
		forever
			begin
				sb_bfm.input_deserializer(data_read_input_nxt);
				data_read_input = data_read_input_nxt;	
			end
	end		
endtask
task execute_2();
	begin
//////////////SCOREBOARD  DESERIALIZER//////////////////////////////////
		state_deserializer = WAIT_FOR_OUTPUT;
		forever
			begin			
				case(state_deserializer)	
 					WAIT_FOR_OUTPUT:
						begin
							read_iterator_output = 54;
							@(negedge sb_bfm.sout);
							@(posedge sb_bfm.clk);
							read_data_output[read_iterator_output] = sb_bfm.sout;
							read_iterator_output--;
							@(posedge sb_bfm.clk);
							read_data_output[read_iterator_output] = sb_bfm.sout;
							read_iterator_output--;
							if(read_data_output[read_iterator_output+1] == 1)
								state_deserializer = READ_OUTPUT_CLT;
							else
								state_deserializer = READ_OUTPUT_DATA;
						end	
					READ_OUTPUT_DATA:
						begin
							repeat(53)
								begin
									@(posedge sb_bfm.clk);
									read_data_output[read_iterator_output] = sb_bfm.sout;
									read_iterator_output--;
								end
							read_number_output = {read_data_output[52:45],read_data_output[41:34],read_data_output[30:23],read_data_output[19:12]};
							read_flags = read_data_output[7:4];
							read_crc_output = read_data_output[3:1];
							state_deserializer = DONE;
						end	
					READ_OUTPUT_CLT:	
						begin
							repeat(9)
								begin
									@(posedge sb_bfm.clk);
									read_data_output[read_iterator_output] = sb_bfm.sout;
									read_iterator_output--;
								end	
							read_err_flags = read_data_output[48:46];
							read_parity_bit = read_data_output[45];
							state_deserializer = DONE;	
						end
					DONE:
						begin
							@(negedge sb_bfm.clk);
							state_deserializer = WAIT_FOR_OUTPUT;
						end
				endcase
			end	
 end
endtask

task execute_3();
	begin
   forever begin : scoreboard
	   @(posedge state_deserializer == DONE); 
	   output_type_rec = read_data_output[54:52];
	   //CHECK INPUT BYTES NUMBER///////////////////////////
	   check_err_flags(data_read_input, predicted_err_flags);
	   //IF OUTPUT MESSAGE WAS DATA////////////////////////
	   if(output_type_rec[2:1] == 2'b00 )
		   begin
			  check_art_flags(data_read_input, predicted_flags, predicted_result, read_op_code);
		      predicted_CRC_output = calc_CRC_output(predicted_result, predicted_flags);
		      if((read_op_code == add_op)|(read_op_code == and_op)|(read_op_code == or_op)|(read_op_code == sub_op)) //CHECK IF OPCODE IS CORRECT
			        if ((predicted_result != read_number_output) | (predicted_flags != read_flags) | (predicted_CRC_output != read_crc_output))
				        begin
				        //  $error ("FAILED: A:   B:   op: %s result: %0d predicted_result: %0d flags: %0b predicted_flags: %0b output crc: %0h predicted output crc: %0h",
				        //           read_op_code.name(), read_number_output, predicted_result, read_flags, predicted_flags, read_crc_output, predicted_CRC_output);
					        $error ("SIMULATION RESULT: FAILED");
					      	$finish; 
				        end	        
		   end	
		//IF OUTPUT MESSAGE WAS ONLY CTL///////////////////////////////////////
	   else if(output_type_rec == 3'b011)
		   begin
		  	   predicted_parity_bit = Check_parity(predicted_err_flags); //CALCULATING PARITY BIT
			   if ((predicted_err_flags != read_err_flags)|(predicted_parity_bit != read_parity_bit)) 
				   begin
		        //  $error ("FAILED: predicted_err_flags: %0b read_err_flags: %0b, predicted_parity_bit: %0b read_parity_bit: %0b",
		          //         predicted_err_flags, read_err_flags, predicted_parity_bit, read_parity_bit);
				   $error ("SIMULATION RESULT: FAILED");
			   	   $finish; 
				   end			   
		   end
		   @(state_deserializer == WAIT_FOR_OUTPUT);
   		end : scoreboard
 end
endtask
endclass
