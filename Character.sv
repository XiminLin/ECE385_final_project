module Character(input logic frame_clk,
				input logic Reset_h,
				input logic [9:0] Reset_X, Reset_Y,
				input logic W, A, D,
				input logic hit_y, hit_top,
				input logic [9:0] Kid_position_Y,
				input logic Ground,
				output logic direction,
				input logic [9:0] DrawX, DrawY,
				input logic collide,
				input logic [9:0] Kid_position_Y_top,
				output logic [24:0] Kid_address,
				output logic isKid,
				output logic [9:0] PositionX, PositionY,
				output logic [9:0] MovementX, MovementY
				);
	
	logic direction_in; // 0 --- left, 1 --- right
	
	enum logic [3:0] {idle, run_1, run_2, jump_1, jump_2, fall_1, fall_2, dead} curr_state, next_state;
	
//	logic [3:0] state;
//	assign state = curr_state;
				
	// PositionX and PositionY are defined as the top-left corner of the image.
//	logic [9:0] PositionX, PositionY;
	logic [9:0] PositionX_in, PositionY_in;
	int PositionX_int, PositionY_int;
	int MovementX_int, MovementY_int;
	// movement of Kid
   logic [9:0] MovementX_in; 
	logic [9:0] MovementY_in;
	
	logic [9:0] initial_x, initial_y;
	// initial position X and Y
	assign initial_x = Reset_X;
	assign initial_y = Reset_Y;
	parameter [9:0] h_motion = 10'd5;
	parameter [9:0] v_motion_0 = 10'd16;
	parameter [9:0] v_motion_1 = 10'd10;
	parameter [9:0] acceleration = 10'd2;
	
	logic jump_counter, jump_counter_in;
	
	// saved position X and Y
	logic [9:0] saved_x, saved_x_in;
	logic [9:0] saved_y, saved_y_in;
	
	// Kid's dimensions
	parameter [9:0] width = 32;
	parameter [9:0] height = 32;
	
	// Boundary
	//parameter [9:0] Xmin = 10'd2;
	parameter [9:0] Xmax = 10'd607;
	//parameter [9:0] Ymin = 10'd2;
	parameter [9:0] Ymax = 10'd447;
	
	logic [9:0] DistX, DistY;
	
	characterAddress cha0(.*, .curr_state(curr_state) );
	
	always_ff @ (posedge frame_clk) begin
		if(Reset_h) begin
			direction <= 1'b1;	// initially right;
			PositionX <= initial_x;
			PositionY <= initial_y;
			MovementX <= 10'd0;
			MovementY <= 10'd0;
			saved_x <= initial_x;
			saved_y <= initial_y;
			curr_state <= idle;
			jump_counter <= 1'b0;
		end
		else begin
			curr_state <= next_state;
			direction <= direction_in;
			PositionX <= PositionX_in;
			PositionY <= PositionY_in;
			saved_x <= saved_x_in;
			saved_y <= saved_y_in;
			MovementX <= MovementX_in;
			MovementY <= MovementY_in;
			jump_counter <= jump_counter_in;
		end
		if(PositionX_in > Xmax)
			PositionX <= PositionX;
		if(PositionY_in > Ymax)
			PositionY <= PositionY;
		
		
	end
	
	assign DistX = DrawX - PositionX;
	assign DistY = DrawY - PositionY;
//	assign PositionX_int = {22'd0,PositionX};
//	assign PositionY_int = {22'd0,PositionY};
//	assign MovementX_int = {22'd0,MovementX};
//	assign MovementY_int = {22'd0,MovementY};
	always_comb begin
		PositionX_in = PositionX + MovementX;
		PositionY_in = PositionY + MovementY; 
		saved_x_in = saved_x;
		saved_y_in = saved_y;
		MovementX_in = 10'd0;
		MovementY_in = 10'd0;
		next_state = curr_state;
		direction_in = direction;
		jump_counter_in = jump_counter;
//		// Press R to reset position
//		if(keycode == 16'd21) begin
//			PositionX_in = saved_x;
//			PositionY_in = saved_y;
//			next_state = idle;
//		end
//		// Press G to save current position
//		else if(keycode == 16'd10) begin
//			saved_x_in = PositionX;
//			saved_y_in = PositionY;
//			next_state = idle;
//		end

		if(hit_y) begin
			PositionY_in = Kid_position_Y;
		end	
		else if(hit_top)
		begin
			PositionY_in = Kid_position_Y_top;
		end
		
		isKid = 1'b0;
		if(DistX < width && DistY < height && DistX >= 0 && DistY >= 0) begin
			isKid = 1'b1;
		end
		

		case(curr_state)
			idle:
			begin
				next_state = idle;
				if(collide)
					next_state = dead;
				else if(~Ground && ~(PositionY + height >= 10'd479))
					next_state = fall_1;
				else if(W)
					next_state = jump_1;
				else if(A)
					next_state = run_1;
				else if(D)
					next_state = run_1;
			
			end
			run_1:
			begin
				next_state = idle;
				if(collide)
					next_state = dead;
				else if(~Ground && ~(PositionY + height >= 10'd479))
					next_state = fall_1;
				else if(W)
					next_state = jump_1;
				else if(A || D)
					next_state = run_2;
			end
			run_2:
			begin
				next_state = idle;
				if(collide)
					next_state = dead;
				else if(~Ground && ~(PositionY + height >= 10'd479))
					next_state = fall_1;
				else if(W)
					next_state = jump_1;
				else if(A || D)
					next_state = run_1;
			end
			jump_1:
			begin
				if(collide)
					next_state = dead;
				else if(MovementY == 10'd0)
					next_state = fall_1;
			end
			jump_2:
			begin
				if(collide)
					next_state = dead;
				else if(MovementY == 10'd0)
					next_state = fall_1;
			end
			fall_1:
			begin
				next_state = fall_2;
				if(collide)
					next_state = dead;
				else if(hit_y || Ground || ((PositionY + height) >= 10'd479) )
					next_state = idle;
				else if(W && jump_counter == 1'd0)
					next_state = jump_1;
					
			end
			fall_2:
			begin
				next_state = fall_1;
				if(collide)
					next_state =dead;
			   else if(hit_y || Ground || ((PositionY + height) >= 10'd479) )
					next_state = idle;
				else if(W && jump_counter == 1'd0)
					next_state = jump_1;
			end
			dead: ;
					
		
		endcase
		case(curr_state)
			idle: begin
				MovementX_in = 10'd0;
				MovementY_in = 10'd0;
				jump_counter_in = 1'd0;
				// W for up
				if(W) begin
//				if(keycode == 16'd26) begin
					MovementY_in = (~(v_motion_0) + 10'd1);	//initial speed upward
				end
				// A for left
				else if(A) begin
//				else if(keycode == 16'd4) begin
					direction_in = 1'b0;
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
				end
			end
			
			run_1: begin
				MovementY_in = 10'd0;
				jump_counter_in = 1'b0;
				// W for up
				if(W) begin
//				if(keycode == 16'd26) begin
					MovementY_in = (~(v_motion_0) + 10'd1);	//initial speed upward
				end
				// A for left
				else if(A) begin
//				else if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
			end
			
			run_2: begin
				MovementY_in = 10'd0;
				jump_counter_in = 1'b0;
				// W for up
				if(W) begin
//				if(keycode == 16'd26) begin
					MovementY_in = (~(v_motion_0) + 10'd1);	//initial speed upward
				end
				// A for left
				else if(A) begin
//				else if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
			end
			
			jump_1:	begin
				MovementX_in = 10'd0;
				MovementY_in = MovementY + acceleration;	// decreasing speed upward
				// W for up
//				if(W) begin
////				if(keycode == 16'd26) begin
//					MovementY_in = (~(v_motion_0) + 10'd1);		// initial second jump speed upward
//					jump_counter_in = 1'b1;
//					next_state = jump_2;
//				end
				// A for left
				if(A) begin
//				else if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
			end
			
			jump_2: begin
				MovementX_in = 10'd0;
				MovementY_in = MovementY + acceleration;	// decreasing speed upward
				// A for left
				if(A) begin
//				if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
				
			end
			
			fall_1: begin
				MovementX_in = 10'd0;
				MovementY_in = MovementY + acceleration;
				// W for up
				if(hit_y || Ground || ((PositionY + height) >= 10'd479) ) begin
					MovementY_in = 10'd0;
				end
				else if(W && jump_counter == 1'b0) begin
//				if(keycode == 16'd26) begin
					MovementY_in = (~(v_motion_1) + 10'd1);	//initial speed upward
					jump_counter_in = 1'b1;
				end
				// A for left
				else if(A) begin
//				if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
				

			end
			
			fall_2: begin
				MovementX_in = 10'd0;
				MovementY_in = MovementY + acceleration;
				// W for up
				if(hit_y || Ground || ((PositionY + height) >= 10'd479) ) begin
					MovementY_in = 10'd0;
				end
				else if(W && jump_counter == 1'b0) begin
//				if(keycode == 16'd26) begin
					MovementY_in = (~(v_motion_1) + 10'd1);	//initial speed upward
					jump_counter_in = 1'b1;
				end
				// A for left
				else if(A) begin
//				if(keycode == 16'd4) begin
					direction_in = 1'b0;
					MovementX_in = (~(h_motion) + 10'd1);
				end
				// D for right
				else if(D) begin
//				else if(keycode == 16'd7) begin
					direction_in = 1'b1;
					MovementX_in = h_motion;
				end
			end
			dead: begin
				isKid = 1'b0;
			end

			
		endcase
		

		
		
		// Boundary check
//		if( PositionX + width >= Xmax ) begin
//			PositionX_in = Xmax + (~(width + 10'd2) + 10'd1);
//		end
//		else if( PositionX <= Xmin) begin
//			PositionX_in = Xmin + 10'd2;
//		end
//		if( PositionY + height >= Ymax) begin
//			PositionY_in = Ymax + (~(height + 10'd2) + 10'd1);
//		end
//		else if( PositionY <= Ymin) begin
//			PositionY_in = Ymin + 10'd2;
//		end
	end
	
endmodule


module characterAddress(input logic [9:0] DistX, DistY,
						input logic [3:0] curr_state,
						input logic isKid,
						input logic direction,
						output logic [24:0] Kid_address);

	logic [31:0] offset,image_off;
	
	always_comb begin

		offset = {22'd0,DistX} + {17'd0,DistY,5'd0};
		image_off = {17'd0,curr_state,11'd0} + {21'd0,(direction),10'd0} + offset;
		if(~isKid) begin
			Kid_address = 25'd0;
		end
		else begin
			Kid_address = image_off[24:0];
		end
	end

endmodule
