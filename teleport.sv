module teleport(
	input logic [9:0] Position_X,Position_Y,
	input logic [9:0] Kid_Position_X, Kid_Position_Y,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic Reset_h,
	input logic frame_clk,
	output logic reach_final,
	output logic isTeleport,
	output logic [24:0] Teleport_address
);

	logic [9:0] start_X,end_X,start_Y,end_Y;
	logic [9:0] Dist_X, Dist_Y;
	int offset;
	assign start_X = Position_X;
	assign end_X = start_X + 10'd31;
	assign start_Y = Position_Y;
	assign end_Y = start_Y + 10'd31;
	assign Dist_X = DrawX_write - start_X;
	assign Dist_Y = DrawY_write - start_Y;
	assign offset = Dist_X + Dist_Y * 32 + 76736;
	
	always_ff @ (posedge frame_clk)
	begin
		reach_final <= reach_final;
		if(Reset_h)
			reach_final <= 1'b0;
		else if(Kid_Position_X + 10'd10 >= start_X && Kid_Position_X + 10'd10 <= end_X && Kid_Position_Y + 10'd15 >= start_Y && Kid_Position_Y + 10'd15 <= end_Y)
			reach_final <= 1'b1;
	
	end
	
	always_comb
	begin
		isTeleport = 1'b0;
		Teleport_address = 25'd0;
		if(DrawX_write >= start_X && DrawX_write <= end_X && DrawY_write >= start_Y && DrawY_write <= end_Y)
		begin
			isTeleport = 1'b1;
			Teleport_address = offset[24:0];
		end
	
	end


endmodule 
