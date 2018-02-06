module Flash_control(input logic slow_clk,
					input logic Clock_50,
					input logic reset_h,
					input logic[1:0] game_state,
					input logic data_over,
					output logic INIT,
					input logic INIT_FINISH,
					output logic [22:0] FL_ADDR,
					output logic FL_CE_N,
					inout wire [7:0] FL_DQ,
					output logic FL_OE_N,
					output logic FL_RST_N,
					input logic FL_RY,
					output logic FL_WE_N,
					output logic FL_WP_N,
					output logic [15:0] LDATA,
					output logic [15:0] RDATA);
		
	logic [15:0] wholeData_in;
	logic [15:0] wholeData;
	logic [1:0] last_game_state;
	
	enum logic [1:0] {start, readFirst, readSecond} curr_state, next_state;
	
	parameter logic [22:0] starts_address0 [4] = '{
		23'd0,
		23'd2000000,
		23'd3323218,
		23'd7686994
	};
	
	parameter logic [22:0] starts_address1 [4] = '{
		23'd1,
		23'd2000001,
		23'd3323219,
		23'd7686995
	};
	
	parameter logic [22:0] ends_address [4] = '{
		23'd1999998,
		23'd3323216,
		23'd7686992,
		23'd8217424
	};
	
	logic [22:0] address0, address1;
	logic [22:0] address0_in, address1_in;
	
	always_ff @ (posedge Clock_50) begin
		if(reset_h) begin
			INIT <= 1'b1;
		end
		else if(INIT_FINISH) begin
			INIT <= 1'b0;
		end
	end
	
	
	always_ff @ (posedge data_over) begin
		if(reset_h) begin
			LDATA <= 16'd0;
			RDATA <= 16'd0;
		end
		else if(INIT_FINISH) begin
			LDATA <= wholeData;
			RDATA <= wholeData;
		end
	end
	
	always_ff @ (posedge slow_clk) begin
		if(reset_h) begin
			curr_state <= start;
			wholeData <= 16'd0;
			address0 <= 23'd0;
			address1 <= 23'd1;
			last_game_state <= 2'd0;
		end
		else begin
			curr_state <= next_state;
			wholeData <= wholeData_in;
			address0 <= address0_in;
			address1 <= address1_in;
			last_game_state <= game_state;
		end
	end
	
	always_comb begin
		FL_RST_N = 1'b1;
		FL_WE_N = 1'b1;
		FL_WP_N = 1'b1;
		FL_ADDR = address0;
		FL_CE_N = 1'b1;
		FL_OE_N = 1'b1;
		wholeData_in = wholeData;
		next_state = curr_state;
		address0_in = address0;
		address1_in = address1;
		case(curr_state)
		
		start: begin
			if(data_over) begin
				next_state = readFirst;
				if(address0 >= ends_address[last_game_state]) begin
					if(last_game_state != 2'd3) begin 	// dead
						address0_in = starts_address0[last_game_state];
						address1_in = starts_address1[last_game_state];
					end
				end
				else begin
					address0_in = address0 + 23'd2;
					address1_in = address1 + 23'd2;
				end
			end
			// change state, change music
			if(last_game_state != game_state) begin
				next_state = start;
				address0_in = starts_address0[game_state];
				address1_in = starts_address1[game_state];
			end
		end
		
		readFirst: begin
			FL_CE_N = 1'b0;
			FL_OE_N = 1'b0;
			FL_ADDR = address0;
			wholeData_in = {8'd0, FL_DQ};
			next_state = readSecond;
		end
		
		readSecond: begin
			FL_CE_N = 1'b0;
			FL_OE_N = 1'b0;
			FL_ADDR = address1;
			wholeData_in = wholeData | {FL_DQ, 8'd0};
			next_state = start;
		end
			
		endcase
	end
		
		
endmodule
