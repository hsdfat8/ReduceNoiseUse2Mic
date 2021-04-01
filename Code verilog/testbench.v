module testbench();
	parameter 			wordsize = 8;
	parameter 			datasize = 24;
	parameter 			fir_length = 16;
	parameter 			data_length = 1017600;
	
	reg signed			[wordsize - 1 : 0] main;
	reg signed			[wordsize - 1 : 0] sub;
	reg 				clk,rst_n;
	reg 				start;
	reg 				start_sample;
	wire signed 		[wordsize - 1 : 0] out;
	
	
	integer 			j = 0, k = 0, addr,addr2;
	reg 				[7:0] patterns1 [0:data_length-1];
	reg 				[7:0] patterns2 [0:data_length-1];
	integer				file_id;
	Reduce_noise DUT(
						.main(main),
						.sub(sub),
						.clk(clk),
						.rst_n(rst_n),
						.start(start),
						.start_sample(start_sample),
						.out(out)
					);
						
	
	initial begin
		#((data_length)*(2*(3*fir_length + 3))); $finish; //thoi gian xu ly toan bo mau 
	end	
	
	// 3*fir_length + 3 = (3*fir_length-1) clk dung de tinh toan va 4 clk nhảy trạng thái, nhân 2 do chu kỳ clk bằng 2 
	
	always begin #(3*fir_length + 3) start_sample = !start_sample; end
	always begin #1 clk = !clk;  end
	
	// dieu kien ban dau
	initial begin
		clk = 1; 
		start_sample = 1;
		rst_n = 1;
		// đọc file dưới dạng bit, đưa toàn bộ dữ liệu vào patterns
		$readmemb("E:\\STUDY\\20191\\TKICS\\BT\\BTL\\main_fq.txt", patterns1);
		$readmemb("E:\\STUDY\\20191\\TKICS\\BT\\BTL\\sub_fq.txt", patterns2);
		#(2*(3*fir_length + 3)-10) start = 1;
	end
	
	// doc du~ lieu tu file txt
	initial begin
		for (addr = 0;addr < data_length-1; addr = addr+1)
			begin
				#(2*(3*fir_length + 3)) main = patterns1[addr];
				 sub = patterns2[addr];
			end
	end
	
	// ghi output ra file txt
	initial begin
		file_id = $fopen("E:\\STUDY\\20191\\TKICS\\BT\\BTL\\output_fq.txt","w");
		#200;
		for (addr2 = 0;addr2 < data_length-1; addr2=addr2+1)
			begin
				#(2*(3*fir_length + 3)) $fwrite(file_id,"%b\n",out);
			end
	end
	
endmodule