module save(
	input logic [9:0] Position_X, Position_Y,
	input logic [9:0] Bullet_X, Bullet_Y,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic frame_clk,
	input logic Reset_h,
	output logic isSave,
	output logic [24:0] Save_address,
	output logic saved,
	output logic hit
);

	logic [9:0] start_X,start_Y,end_X,end_Y;
	logic [9:0] Dist_X, Dist_Y;
	logic saved_in, hit_in;
	int offset1,offset2;
	assign start_X = Position_X;
	assign start_Y = Position_Y;
	assign end_X = start_X + 10'd32;
	assign end_Y = start_Y + 10'd32;
	assign Dist_X = DrawX_write - start_X;
	assign Dist_Y = DrawY_write - start_Y;
	assign offset1 = Dist_X + Dist_Y * 32 + 241600;
	assign offset2 = Dist_X + Dist_Y * 32 + 242624;
	enum logic [3:0] {ready, red1, red2, disappear} state, next_state;
	
	always_ff @ (posedge frame_clk)
	begin
		state <= next_state;
		saved <= saved_in;
		hit <= hit_in;
		if(Reset_h)
		begin
			state <= ready;
			saved <= 1'b0;
			hit <= 1'b0;
		end
	end
	
	always_comb
	begin
		next_state = state;
		case(state)
			ready:
				if(Bullet_X > start_X && Bullet_X < end_X && Bullet_Y > start_Y && Bullet_Y < end_Y)
					next_state = red1;
			red1:
				next_state = red2;
			red2:
				next_state = disappear;
			disappear: ;
		endcase
		isSave = 1'b0;
		Save_address = 25'd0;
		

		hit_in = hit;
		saved_in = saved;
		case(state)
			ready:
			begin
				if(DrawX_write > start_X && DrawX_write < end_X && DrawY_write > start_Y && DrawY_write < end_Y)
				begin
					isSave = 1'b1;
					Save_address = offset1[24:0];
				end
			end
			red1:
			begin
				saved_in = 1'b1;
				hit_in = 1'b1;
				if(DrawX_write > start_X && DrawX_write < end_X && DrawY_write > start_Y && DrawY_write < end_Y)
				begin
					isSave = 1'b1;
					Save_address = offset2[24:0];
				end
			end
			red2:
			begin
				saved_in = 1'b0;
				hit_in = 1'b0;
				if(DrawX_write > start_X && DrawX_write < end_X && DrawY_write > start_Y && DrawY_write < end_Y)
				begin
					isSave = 1'b1;
					Save_address = offset2[24:0];
				end
			end	
			disappear:
			begin
				hit_in = 1'b0;
				saved_in = 1'b0;
			end
		endcase
	end
	

	
endmodule 