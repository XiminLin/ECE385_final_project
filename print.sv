module print(
   input logic clk_100,
	input logic Reset_h,
	//input logic isKid,
	input logic new_frame,
	input logic wait_request,
	input logic sdram_valid,
	input logic buffer_full,
	output logic sdram_read_n,
	output logic [9:0] DrawX_write,
	output logic [9:0] DrawY_write,
	//input logic [24:0] Kid_address,
	input logic [24:0] Address,
	input logic [31:0] sdram_data_in,
	output logic [24:0] sdram_address,
	output logic [31:0] buffer_data, //data read from sdram will be sent to buffer first_match
	output logic push, //tell the buffer to read the valid data
	output logic sig_test,
	output logic sdram_cs
	//output logic [15:0] sram_data_out
);
	parameter [9:0] H_TOTAL = 10'd640; //here we only print 640*480 pixels
	parameter [9:0] V_TOTAL = 10'd480;
	logic [9:0] h_counter, v_counter;
	logic [9:0] h_counter_in, v_counter_in;
	enum logic [3:0] {reset, initialization, normal} state, next_state;
	assign DrawX_write = h_counter;
	assign DrawY_write = v_counter;
	logic [2:0] counter,counter_in; //counter to count 4 cycles delay and then read data
	
	always_ff @ (posedge clk_100)
	begin
		sig_test <= 1'b0;
		state <= next_state;
		h_counter <= h_counter_in;
		v_counter <= v_counter_in;
		counter <= counter_in;
//		reset_counter <= reset_counter_in;
//		if(v_counter_in > 10'd240)
//		begin
//			buffer_data <= {16'd9,16'd0};
//		/*	if(h_counter > 320)
//				buffer_data <= {16'd1,16'd0};*/
//		end
//		else	
//		begin
//			buffer_data <= sdram_data_in;
//		end

		if(v_counter == 10'd0)
			sig_test <= 1'b1;
		if(Reset_h == 1'b1)
		begin
			state <= reset;
//			wait_counter <= 2'd3;
		end

	end
	
	
	always_comb
	begin

		buffer_data = sdram_data_in;
		
		next_state = state; //default case
		case(state)
			reset:
			begin
			if(wait_request == 1'b0)
					next_state = initialization;
			end
			initialization: 
			begin
				if(counter == 3'd5) //we have delayed 4 cycles now, enter the normal mode
					next_state = normal;
			end
			normal:
			begin
				if(new_frame == 1'b1)
					next_state = reset;
			end
			default: ;
		endcase
		
		
		h_counter_in = h_counter + 10'd1;
		v_counter_in = v_counter;
		if(h_counter + 10'd1 == H_TOTAL)
		begin
			h_counter_in = 10'd0;
			v_counter_in = v_counter + 10'd1;
			if(v_counter > 10'd480)
				v_counter_in = 10'd490;
		end
		
		
		push = 1'b1;
		sdram_read_n = 1'b0;
		sdram_address = Address;
		if(v_counter == 10'd0)
			sdram_address = {15'd0,h_counter};
		sdram_cs = 1'b1;
		counter_in = 3'd0;
		case(state)
			reset:
			begin
				h_counter_in = 10'd0;
				v_counter_in = 10'd0;
				push = 1'b0;
				counter_in = 3'd0;
			end
			
			initialization:
			begin
				counter_in = counter + 3'd1;
				push = 1'b0; //the data is not valid until 5 cycles later
			if(wait_request == 1'b1) //we need to wait until sdram can work
				begin
					h_counter_in = h_counter;
					v_counter_in = v_counter;
					counter_in = counter;  
				end 
			end
			
			normal:
			begin
				if(sdram_valid == 1'b0)
					push = 1'b0;
				if(wait_request) //we should stop updating the address
				begin
					h_counter_in = h_counter;
					v_counter_in = v_counter;
				end  
				else if(buffer_full == 1'b1)
				begin
					h_counter_in = h_counter;
					v_counter_in = v_counter;
					sdram_read_n = 1'b1;
					sdram_cs = 1'b0;
				end
				
			end
			default: ;
		endcase
 	end

/*	always_ff @ (posedge clk_100)
	begin
		sdram_address <= Kid_address;
	end
	
	always_comb
	begin
		sram_data_out = sdram_data_in[31:16];
		if(isKid == 1'b0)
			sram_data_out = 16'h0000;
	end
*/


endmodule

