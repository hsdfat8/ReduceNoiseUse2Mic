module Reduce_noise #(	parameter wordsize = 8,               			// do dai cua main, sub, output
						parameter datasize = 24,						// do dai cua data duoc xu ly, them 16 bit ben phai de tinh toan chinh xac
						parameter fir_length = 16						// do dai cua bo loc fir
						)
					(
						input signed	[wordsize - 1 : 0] main,		// tin hieu chinh
						input signed	[wordsize - 1 : 0] sub,			// tin hieu nhieu can` phai loc di trong tin hieu chinh
						input 	start_sample,							// tin hieu de lay mau~	
						input 	clk,rst_n,								// clock va reset suon` am
						input 	start,									// tin hieu bao' bat' dau` thuc hien
						output signed 	[wordsize - 1 : 0] out
						);
	wire 	inc_i, clr_i;												// bien dem			
	wire 	read_main, read_sub;										// tin hieu doc main, sub
	wire 	inc_ptr;													// tin hieu tang con tro
	wire 	write_new_mem, update_mem;									// tin hieu ghi du lieu moi vao trong memory, tin hieu update memory
	wire 	weight_update;												// tin hieu cap nhat he so cua bo loc fir
	wire 	compute_error;												// tin hieu tinh toan
	wire 	write_output;												// tin hieu ghi ra output
	wire 	i_equal_fir_length;											// tin hieu bao hieu bien dem i = fir_length
	wire 	i_equal_fir_length_minus_1;									// tin hieu bao hieu bien dem i = fir_length - 1

	// goi ham datapath va controller
	datapath #(
				.wordsize(wordsize),
				.datasize(datasize),
				.fir_length(fir_length)	
				)
			data1(
				.clk(clk),
				.rst_n(rst_n),
				.main(main),
				.sub(sub),
				.inc_i(inc_i),
				.clr_i(clr_i),
				.read_main(read_main),
				.read_sub(read_sub),
				.inc_ptr(inc_ptr),
				.write_new_mem(write_new_mem),
				.update_mem(update_mem),
				.weight_update(weight_update),
				.compute_error(compute_error),
				.write_output(write_output),
				
				.out(out),
				.i_equal_fir_length(i_equal_fir_length),
				.i_equal_fir_length_minus_1(i_equal_fir_length_minus_1)
				);
				
	controller #(
				.wordsize(wordsize),
				.datasize(datasize),
				.fir_length(fir_length)
				)			
			controller1(
				.clk(clk),
				.rst_n(rst_n),
				.start(start),
				.i_equal_fir_length(i_equal_fir_length),
				.i_equal_fir_length_minus_1(i_equal_fir_length_minus_1),
				.start_sample(start_sample),
				
			
				.inc_i(inc_i),
				.clr_i(clr_i),
				.read_main(read_main),
				.read_sub(read_sub),
				.inc_ptr(inc_ptr),
				.write_new_mem(write_new_mem),
				.update_mem(update_mem),
				.weight_update(weight_update),
				.compute_error(compute_error),
				.write_output(write_output)
			);	
endmodule		





					