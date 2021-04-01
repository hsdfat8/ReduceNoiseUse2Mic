module datapath#(
					parameter wordsize = 8,
					parameter datasize = 24,
					parameter fir_length = 16
					)
				(
					input clk,
					input rst_n,
					input signed [wordsize - 1 : 0] main,
					input signed [wordsize - 1 : 0] sub,
					input inc_i,
					input clr_i,
					input read_main,
					input read_sub,
					input inc_ptr,
					input write_new_mem,
					input update_mem,
					input weight_update,
					input compute_error,
					input write_output,
					
					output reg signed [wordsize - 1 : 0]out,
					output reg i_equal_fir_length,
					output reg i_equal_fir_length_minus_1
					);
	localparam 	ptr_length = 4;								// do dai con tro, khai bao ham noi bo
	localparam	mem_length = 2**ptr_length;					// do dai memory
					
	reg signed 		[datasize - 1:0] 	mem [mem_length - 1:0];
	reg signed		[datasize - 1:0]	weightFIR[fir_length - 1:0];
	reg signed		[datasize - 1:0] 	u [fir_length - 1:0] ;	
	reg signed		[datasize - 1:0] 	error = 0;
	reg signed		[datasize - 1:0] 	out_mult = 0;
	reg 			[ptr_length:0] 		i = 0;
	reg  			[ptr_length - 1:0] 	ptr = 0;	
	reg				[ptr_length - 1:0] 	ptr2 = 0;	
	reg signed		[2*datasize - 1:0] 	mult_out = 0;
	integer 		k;
	// khai bao dieu kien dau
	initial begin
	for (k = 0; k<mem_length;k=k+1) begin
		mem [k] = 0;
	end
	for (k = 0; k<fir_length;k=k+1) begin
		weightFIR [k] = 0;
	end
	for (k = 0; k<fir_length;k=k+1) begin
		u[k] = 0;
	end
	end
	
	
	always @ (posedge clk or negedge rst_n) begin
		if (rst_n == 0) 
			begin 
				i <= 0;
				out <= 0; 
				ptr <= 0;
			end
		else
			begin
				if (clr_i) i = 0;
				// them 16 bit 0 vao ben phải để khi thực hiện phép tính có độ chính xác cao hơn 
				if (read_main) error = {main, 16'b0};
				if (read_sub) u[fir_length - 1] =  {sub, 16'b0};
				if (inc_ptr) ptr = ptr + 1;	
				if (write_new_mem) 
					begin
						//luu gia tri vao memory theo cach circle buffer, tuc la chi can thay gia tri moi nhat vao gia tri cu nhat trong buffer
						//con tro ptr tang them 1 qua moi lan update, se reset bang 0 khi bang 15 + 1
						//con tro ptr2 de gan gia tri do khong gan duoc mem[ptr + fir_length - 1], cũng sẽ reset khi vượt quá 15 
						ptr2 = ptr + fir_length - 1;
						mem[ptr2] = u[fir_length - 1];
					end	
				
				if (update_mem)
					begin
						ptr2 = ptr + i;
						u[i] = mem [ptr2];
					end	
				if (weight_update) 
					begin
						mult_out = u[i]*error;
						out_mult = {mult_out[2*datasize-1], mult_out[2*datasize-3:datasize-1]}; 	// lấy bit dấu và bỏ đi 23 bit(7 bit do lượng tử hóa, 16 bit do phép nhân)
						
						// dich phai 6 bit (phep chia), phép >>> không hoạt động
						if(out_mult[datasize-1])out_mult = {out_mult[datasize-1],6'b111111,out_mult[datasize-2:6]};
						else out_mult = {out_mult[datasize-1],6'b0,out_mult[datasize-2:6]};
						
						// cap nhat he so cua bo loc
						weightFIR[fir_length-1-i] = weightFIR[fir_length-1-i] + out_mult;
					end
				// tinh toan dau ra	
				if (compute_error)
					begin 
						mult_out = u[i]*weightFIR[fir_length-1-i];
						out_mult = {mult_out[2*datasize-1], mult_out[2*datasize-3:datasize-1]};
						error = error - out_mult;
					end	
				// ghi đầu ra, chỉ lấy 8 bit đầu bên trái	
				if (write_output) out = error [datasize-1:datasize-wordsize];
				if (inc_i) i = i+1;	
				if (i == fir_length) i_equal_fir_length = 1;
					else i_equal_fir_length = 0;
				if (i == fir_length - 1) i_equal_fir_length_minus_1 = 1;
					else i_equal_fir_length_minus_1 = 0;
				
			end
	end				
endmodule