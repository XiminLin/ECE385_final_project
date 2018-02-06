module sdram_buffer(input logic sram_read_ready,
					input logic new_frame,
					input logic CLOCK_100,
					input logic Reset_h,
					input logic sdram_valid,
					input logic [31:0] sdram_data_in,
					output logic [19:0] sram_write_addr,
					output logic [15:0] sram_data_out,
					output logic full);
					
	logic [5:0] in_idx, out_idx;
	logic [5:0] in_idx_in, out_idx_in;
	
	logic [19:0] count_in, count_out;
	logic [19:0] count_in_in, count_out_in;
	logic empty;
	enum logic {amfull, amfree} full_state, full_state_next;
	logic [9:0] sram_X, sram_Y;
	logic [9:0] sram_X_in, sram_Y_in;
	int sram_X_int, sram_Y_int;
	assign sram_X_int = sram_X;
	assign sram_Y_int = sram_Y;
	logic [15:0] registers[64];
	logic status;
	
	always_ff @ (posedge CLOCK_100) begin
		if(Reset_h || new_frame) begin
			count_in <= 20'd0;
			count_out <= 20'd0;
			out_idx <= 6'd0;
			in_idx <= 6'd0;			// -1 to account for one clock delay in valid and sdram_data_in
			sram_X <= 10'd0;
			sram_Y <= 10'd0;
			for(int i = 0; i < 64; i++) begin
				registers[i] <= 16'd0;
			end
		end
		else begin
			sram_X <= sram_X_in;
			sram_Y <= sram_Y_in;
			count_out <= count_out_in;
			out_idx <= out_idx_in;
			count_in <= count_in_in;
			in_idx <= in_idx_in;
			if(sdram_valid) 
				registers[in_idx] <= sdram_data_in[31:16];
		end
		if(Reset_h || new_frame) begin
			status <= 1'b0;
		end
		else if(sram_read_ready == 1'b1 && ~empty) begin
			status <= 1'b1;
		end
	end	
	
	// sram_data_out
	assign sram_data_out = registers[out_idx];
	
	
	
	// sram_X_in and sram_Y_in
	always_comb begin
		sram_X_in = sram_X;
		sram_Y_in = sram_Y;
		if(sram_read_ready && ~empty && status) begin
			if(registers[out_idx] == 16'hffff && count_out < 20'd40)
			begin
				sram_X_in = 10'd33;
				sram_Y_in = 10'd0;
			end
			else if(sram_X < 10'd639)
				sram_X_in = sram_X + 10'd1;
			else if(sram_Y < 10'd479) begin
				sram_X_in = 10'd0;
				sram_Y_in = sram_Y + 10'd1;
			end
			else begin
				sram_X_in = 10'd0;
				sram_Y_in = 10'd490;		// assign invalid address
			end
		end	
	end
	
	// sram_write_addr
	always_comb begin
		if(Reset_h)
			sram_write_addr = 20'h5FFFF;
		else
			sram_write_addr = 800*sram_Y_int + sram_X_int;
	end
	
	// out_idx_in and count_out_in
	always_comb begin
		out_idx_in = out_idx;
		count_out_in = count_out;
		if(~sram_read_ready && ~empty && status) begin		// update at Read state
			out_idx_in = out_idx + 6'd1;
			count_out_in = count_out + 20'd1;
		end
	end
	
	// in_idx_in
	always_comb begin
		in_idx_in = in_idx;
		count_in_in = count_in;
		if(sdram_valid) begin
			in_idx_in = in_idx + 6'd1;
			count_in_in = count_in + 20'd1;
		end
	end
	
	// empty
	assign empty = (count_in == count_out);
	
	// full
	always_ff @ (posedge CLOCK_100) begin
		if(Reset_h)
			full_state <= amfree;
		else
			full_state <= full_state_next;
	end
	
	always_comb 
	begin
		full_state_next = full_state;
		full = 1'd1;	
		case(full_state)
			amfull:
			begin
				full = 1'd1;
					if(count_in < count_out + 20'd32)
						full_state_next = amfree;
			end
			amfree:
			begin
				full = 1'd0;
				if(count_in >= (count_out + 20'd59))
					full_state_next = amfull;
			end
		
		endcase
	
	end
	
	
	
	
	
	
	

	
endmodule
