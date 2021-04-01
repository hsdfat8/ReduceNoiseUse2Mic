module controller #(
					parameter wordsize = 8,
					parameter datasize = 24,
					parameter fir_length = 16
					)					
				(
				input 	clk,rst_n,
				input 	start,
				input 	i_equal_fir_length,
				input	i_equal_fir_length_minus_1,
				input 	start_sample,
				
				output reg 	inc_i,
				output reg	clr_i,
				output reg	read_main,
				output reg	read_sub,
				output reg	inc_ptr,
				output reg	write_new_mem,
				output reg	update_mem,
				output reg	weight_update,
				output reg	compute_error,
				output reg	write_output
				);
				
	// khai bao hang noi bo, ma hoa trang thai			
	localparam 	Idle 			= 3'b100;
	localparam 	Start 			= 3'b001;
	localparam 	FIR_update		= 3'b011;
	localparam	Mem_update		= 3'b010;
	localparam	Compute			= 3'b000;
	
	
	reg [2:0]state = Idle, next_state;
	
	
	always @ (posedge clk or negedge rst_n)
    //reset
	if(!rst_n)
        state <= Idle;
    else
		state <= next_state;
	// khi co clock hoac tin hieu vao
	always @ (state or start_sample or i_equal_fir_length or i_equal_fir_length_minus_1 or start)
		begin
			case(state)
				Idle:
					begin
						if (start) 
							begin
								inc_i			= 0;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state = Start;
							end
						else 
							begin
								inc_i			= 0;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state = Idle;
							end
					end
				
				Start:
					begin
						if (start_sample) 
							begin
								inc_i			= 0;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= FIR_update;
							end
						else
							begin
								inc_i			= 0;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= Start;
							end	
					end
					
				FIR_update:
					begin
						if (i_equal_fir_length)
							begin
								
								inc_i			= 0;
								clr_i			= 1;
								read_main 		= 0;
								read_sub 		= 1;
								inc_ptr 		= 1;
								write_new_mem	= 1;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= Mem_update;
							end
						else
							begin
								weight_update 	= 1;
								inc_i			= 1;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= FIR_update;
							end
					end
				Mem_update:
					begin
						if	(i_equal_fir_length_minus_1)
							begin
								inc_i			= 0;
								clr_i			= 1;
								read_main 		= 1;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= Compute;		
							end
						else
							begin
								update_mem 		= 1;
								inc_i			= 1;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= Mem_update;
							end
					end
				
				Compute:
					begin
						if (i_equal_fir_length)
							begin								
								inc_i			= 0;
								clr_i			= 1;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 1;
								next_state 		= Start;

							end
						else
							begin
								compute_error 	= 1;
								inc_i			= 1;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								write_output 	= 0;
								next_state 		= Compute;							
							end
					end
				default:
					begin
								inc_i			= 0;
								clr_i			= 0;
								read_main 		= 0;
								read_sub 		= 0;
								inc_ptr 		= 0;
								write_new_mem	= 0;
								update_mem 		= 0;
								weight_update 	= 0;
								compute_error 	= 0;
								write_output 	= 0;
								next_state 		= Idle;
					end
			endcase
		end
endmodule					