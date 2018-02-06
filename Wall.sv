module Wall_set2(
	input logic [9:0] Kid_position_X, Kid_position_Y,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic [9:0] Kid_move_X, Kid_move_Y,
	output logic hit_y, hit_top,
	output logic [9:0] Kid_position_Y_hit, Kid_position_Y_top,
	output logic isWall,
	output logic [24:0] Wall_address,
	output logic Ground

);

	logic hit_y_r [4];
	logic hit_top_r [4];
	logic [9:0] Kid_position_Y_top_r [4];
	logic [9:0] Kid_position_Y_hit_r [4];
	logic isWall_r [4];
	logic [24:0] Wall_address_r [4];
	logic ground_r [4];
	Wall Wall_1(
				.start_X(10'd0),.start_Y(10'd448),
				.height(10'd31),.width(10'd639),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[0]), .hit_top(hit_top_r[0]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[0]), .Kid_position_Y_top(Kid_position_Y_top_r[0]),
				.isWall(isWall_r[0]),.Wall_address(Wall_address_r[0]),.ground(ground_r[0]));

	Wall Wall_2(
				.start_X(10'd0),.start_Y(10'd382),
				.height(10'd31),.width(10'd120),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[1]), .hit_top(hit_top_r[1]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[1]), .Kid_position_Y_top(Kid_position_Y_top_r[1]),
				.isWall(isWall_r[1]),.Wall_address(Wall_address_r[1]),.ground(ground_r[1])
				);

				
	Wall Wall_3(
				.start_X(10'd519),.start_Y(10'd382),
				.height(10'd31),.width(10'd120),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[2]), .hit_top(hit_top_r[2]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[2]), .Kid_position_Y_top(Kid_position_Y_top_r[2]),
				.isWall(isWall_r[2]),.Wall_address(Wall_address_r[2]),.ground(ground_r[2])
				);	
				
				
	Wall Wall_4(
				.start_X(10'd219),.start_Y(10'd382),
				.height(10'd31),.width(10'd200),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[3]), .hit_top(hit_top_r[3]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[3]), .Kid_position_Y_top(Kid_position_Y_top_r[3]),
				.isWall(isWall_r[3]),.Wall_address(Wall_address_r[3]),.ground(ground_r[3])
				);	
				
	assign Wall_address = Wall_address_r[0]|Wall_address_r[1]|Wall_address_r[2]|Wall_address_r[3];
	assign isWall = isWall_r[0]|isWall_r[1]|isWall_r[2]|isWall_r[3];
	assign Kid_position_Y_hit = Kid_position_Y_hit_r[0] | Kid_position_Y_hit_r[1]|Kid_position_Y_hit_r[2]|Kid_position_Y_hit_r[3];
	assign Ground = ground_r[0]|ground_r[1]|ground_r[2] | ground_r[3];
	assign hit_y = hit_y_r[0]|hit_y_r[1]|hit_y_r[2]|hit_y_r[3];
	assign hit_top = hit_top_r[0]|hit_top_r[1]|hit_top_r[2]|hit_top_r[3];
	assign Kid_position_Y_top = Kid_position_Y_top_r[0]|Kid_position_Y_top_r[1]|Kid_position_Y_top_r[2]|Kid_position_Y_top_r[3];

endmodule 

module Wall_set(
	input logic [9:0] Kid_position_X, Kid_position_Y,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic [9:0] Kid_move_X, Kid_move_Y,
	output logic hit_y, hit_top,
	output logic [9:0] Kid_position_Y_hit, Kid_position_Y_top,
	output logic isWall,
	output logic [24:0] Wall_address,
	output logic Ground
);

logic hit_y_r [3];
logic hit_top_r [3];
logic [9:0] Kid_position_Y_top_r [3];
logic [9:0] Kid_position_Y_hit_r [3];
logic isWall_r [3];
logic [24:0] Wall_address_r [3];
logic ground_r [3];

Wall Wall_1(
				.start_X(10'd0),.start_Y(10'd448),
				.height(10'd31),.width(10'd639),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[0]), .hit_top(hit_top_r[0]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[0]), .Kid_position_Y_top(Kid_position_Y_top_r[0]),
				.isWall(isWall_r[0]),.Wall_address(Wall_address_r[0]),.ground(ground_r[0]));

Wall Wall_2(
				.start_X(10'd0),.start_Y(10'd138),
				.height(10'd31),.width(10'd500),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[1]), .hit_top(hit_top_r[1]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[1]), .Kid_position_Y_top(Kid_position_Y_top_r[1]),
				.isWall(isWall_r[1]),.Wall_address(Wall_address_r[1]),.ground(ground_r[1])
				);

				
Wall Wall_3(
				.start_X(10'd214),.start_Y(10'd276),
				.height(10'd31),.width(10'd500),
				.DrawX_write,.DrawY_write,
				.Kid_position_X,.Kid_position_Y,
				.Kid_move_X,.Kid_move_Y,
				.hit_y(hit_y_r[2]), .hit_top(hit_top_r[2]),
				.Kid_position_Y_hit(Kid_position_Y_hit_r[2]), .Kid_position_Y_top(Kid_position_Y_top_r[2]),
				.isWall(isWall_r[2]),.Wall_address(Wall_address_r[2]),.ground(ground_r[2])
				);	

				
				
				
assign Wall_address = Wall_address_r[0]|Wall_address_r[1]|Wall_address_r[2];
assign isWall = isWall_r[0]|isWall_r[1]|isWall_r[2];
assign Kid_position_Y_hit = Kid_position_Y_hit_r[0] | Kid_position_Y_hit_r[1]|Kid_position_Y_hit_r[2];
assign Ground = ground_r[0]|ground_r[1]|ground_r[2];
assign hit_y = hit_y_r[0]|hit_y_r[1]|hit_y_r[2];
assign hit_top = hit_top_r[0]|hit_top_r[1]|hit_top_r[2];
assign Kid_position_Y_top = Kid_position_Y_top_r[0]|Kid_position_Y_top_r[1]|Kid_position_Y_hit_r[2];



endmodule




//this module can be defined as arbitrary rectangle shape wall 
//we need to specify the position of left upper corner, width and height


module Wall(
		 input logic [9:0] start_X, start_Y,
		 input logic [9:0] height, width,
		 input logic [9:0] DrawX_write, DrawY_write,
		 input logic [9:0] Kid_position_X, Kid_position_Y,
		 input logic [9:0] Kid_move_X, Kid_move_Y,
		 output logic hit_y, hit_top,
		 output logic [9:0] Kid_position_Y_hit, Kid_position_Y_top,
		 output logic ground,
		 output logic isWall,
		 output logic [24:0] Wall_address
);

	
	
	int offset;
	logic [9:0] DistX,DistY;
	int DistX_int, DistY_int;
	logic [9:0] end_X, end_Y;
	logic [9:0] Kid_future_X, Kid_future_Y;
	assign Kid_future_X = Kid_position_X + Kid_move_X;
	assign Kid_future_Y = Kid_position_Y + Kid_move_Y;
	assign end_X = start_X + width;
	assign end_Y = start_Y + height;
	assign DistX = DrawX_write - start_X;
	assign DistY = DrawY_write - start_Y;
	assign DistX_int = {27'd0,DistX[4:0]};
	assign DistY_int = DistY;
	assign offset = DistX_int + DistY_int * 32 + 1165248;
	always_comb
	begin
	
		ground = 1'b0;
		if(Kid_position_Y + 10'd32 == start_Y && Kid_position_X + 10'd20 >= start_X && Kid_position_X + 10'd10 <= end_X)
			ground = 1'b1;
	
		isWall = 1'b0; //default case
		Wall_address = 25'd0;
		hit_y = 1'b0;
		hit_top = 1'b0;
		Kid_position_Y_hit = 10'd0;
		Kid_position_Y_top = 10'd0;

		if((DrawX_write >= start_X && DrawX_write <= end_X) && (DrawY_write >= start_Y && DrawY_write <= end_Y))
		begin
			isWall = 1'b1;
			Wall_address = offset[24:0];
		end
		
		
		
//		if(1)
//		//if(Kid_future_Y >= start_Y && Kid_future_Y <= end_Y ) //move to left
//		begin
//			if(Kid_position_X >= end_X && Kid_future_X <= end_X)
//			begin
//				hit_x = 1'b1;
//				Kid_position_X_hit = end_X + 10'd1;
//			end
//			else if((Kid_position_X+10'd31) <= start_X && (Kid_future_X+10'd31) >= start_X)
//			begin
//				hit_x = 1'b1;
//				Kid_position_X_hit = start_X +(~10'd33 + 1);
//			end
//		end
		
		if(Kid_future_X + 10'd20 >= start_X && (Kid_future_X + 10'd10) <= end_X) 
		begin
			if((Kid_position_Y + 10'd32) <= start_Y && (Kid_future_Y + 10'd32) > start_Y) //move down
			begin
				hit_y = 1'b1;
				Kid_position_Y_hit = start_Y - 10'd32;
			end
			else if((Kid_position_Y + 10'd10) >= (start_Y + 10'd32) && (Kid_future_Y+ 10'd10) < (start_Y + 10'd32)) //move up
			begin	
				hit_top = 1'b1;
				Kid_position_Y_top = start_Y + 10'd22;
			end
		end
		
		
end


endmodule 