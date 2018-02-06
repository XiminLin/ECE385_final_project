module allApple(input logic frame_clk,
				input logic Reset_h,
				input logic [9:0] DrawX, DrawY,
				input logic [9:0] Kid_position_X, Kid_position_Y,
				output logic isApple,
				output logic [24:0] Apple_address,
				output logic hitApple
				);
				
	logic [9:0] apple0_x, apple0_y;
	logic [9:0] apple1_x, apple1_y;
	logic [9:0] apple2_x, apple2_y;
	logic [9:0] apple3_x, apple3_y;
	logic [9:0] apple4_x, apple4_y;
	logic [9:0] apple5_x, apple5_y;
	logic [9:0] apple6_x, apple6_y;
//	assign apple0_x = 10'd3;
//	assign apple0_y = 10'd142;
//	assign apple1_x = 10'd131;
//	assign apple1_y = 10'd142;
	assign apple3_x = 10'd387;
	assign apple4_x = 10'd344;
//	assign apple6_x = 10'd600;
//	assign apple6_y = 10'd280;
	
	logic [24:0] Apple_address0, Apple_address1, Apple_address2, Apple_address3, Apple_address4,Apple_address5, Apple_address6,Apple_address7;	
	logic isApple0, isApple1, isApple2, isApple3, isApple4,isApple5,isApple6,isApple7;
	logic hitApple0, hitApple1, hitApple2, hitApple3, hitApple4, hitApple5, hitApple6, hitApple7;

	apple a0(.*, .PositionX(apple0_x), .PositionY(apple0_y), .Apple_address(Apple_address0), .isApple(isApple0), .hitApple(hitApple0) );
	apple a1(.*, .PositionX(apple1_x), .PositionY(apple1_y), .Apple_address(Apple_address1), .isApple(isApple1), .hitApple(hitApple1) );
	apple a2(.*, .PositionX(apple2_x), .PositionY(apple2_y), .Apple_address(Apple_address2), .isApple(isApple2), .hitApple(hitApple2) );
	apple a3(.*, .PositionX(apple3_x), .PositionY(apple3_y), .Apple_address(Apple_address3), .isApple(isApple3), .hitApple(hitApple3) );
	apple a4(.*, .PositionX(apple4_x), .PositionY(apple4_y), .Apple_address(Apple_address4), .isApple(isApple4), .hitApple(hitApple4) );
	apple a5(.*, .PositionX(apple5_x), .PositionY(apple5_y), .Apple_address(Apple_address5), .isApple(isApple5), .hitApple(hitApple5) );
	apple a6(.*, .PositionX(apple6_x), .PositionY(apple6_y), .Apple_address(Apple_address6), .isApple(isApple6), .hitApple(hitApple6) );
	//apple a7(.*, .PositionX(apple7_x), .PositionY(apple7_y), .Apple_address(Apple_address7), .isApple(isApple7), .hitApple(hitApple7) );
	assign Apple_address = Apple_address0 | Apple_address1 | Apple_address2 | Apple_address3 | Apple_address4 | Apple_address5 | Apple_address6;
	assign isApple = isApple0 | isApple1 | isApple2 | isApple3 | isApple4 | isApple5 | isApple6;
	assign hitApple = hitApple0 | hitApple1 | hitApple2 | hitApple3 | hitApple4 | hitApple5 | hitApple6;
	
	//trap 1
	enum logic [3:0] {ready, fall, finish} state_apple3, next_state_apple3;
	parameter [9:0] apple3_vspeed = 10'd8;
	logic [4:0] apple3_counter,apple3_counter_in;
	logic [9:0] apple3_y_in;
	
	always_ff @ (posedge frame_clk)
	begin
		apple3_y <= apple3_y_in;
		apple3_counter <= apple3_counter_in;
		state_apple3 <= next_state_apple3;
		if(Reset_h)
		begin
			apple3_y <= 10'd142;
			apple3_counter <= 5'd0;
			state_apple3 <= ready;
		end
	end
	
	always_comb
	begin
		next_state_apple3 = state_apple3; //default case
		case(state_apple3)
		ready:
			if(Kid_position_X > 10'd392 && Kid_position_X < 10'd408 && Kid_position_Y > 10'd138)
				next_state_apple3 = fall;
		fall:
			if(apple3_counter == 5'd15)
				next_state_apple3 = finish;
		finish: ;
		endcase
		
		apple3_y_in = apple3_y; //default case
		apple3_counter_in = apple3_counter;
		case(state_apple3)
		ready:
			apple3_counter_in = 5'd0;
		fall:
		begin
			apple3_y_in = apple3_y + apple3_vspeed;
			apple3_counter_in = apple3_counter + 5'd1;
		end
		finish:
		begin
			apple3_y_in = 10'd500;
			apple3_counter_in = 5'd0;
		end
		endcase
		
	end
	//trap 2
	
	enum logic [2:0] {ready_s4, oscillate1,oscillate1_2,oscillate2,oscillate2_2} state_apple4, next_state_apple4;
	logic [9:0] apple4_y_in;
	always_ff @ (posedge frame_clk)
	begin
		state_apple4 <= next_state_apple4;
		apple4_y <= apple4_y_in;
		if(Reset_h)
		begin
			state_apple4 <= ready_s4;
			apple4_y <= 10'd280;
		end
	end
	
	always_comb
	begin
		next_state_apple4 = state_apple4; //default case
		case(state_apple4)
			ready_s4:
				if(Kid_position_X >= 10'd344 && Kid_position_X <= 10'd360 && Kid_position_Y > 10'd138)
					next_state_apple4 = oscillate1;
			oscillate1:
				next_state_apple4 = oscillate1_2;
			oscillate1_2:
				next_state_apple4 = oscillate2;
			oscillate2:
				next_state_apple4 = oscillate2_2;
			oscillate2_2:
				next_state_apple4 = oscillate1;
		endcase
		
		apple4_y_in = apple4_y;
		case(state_apple4)
			ready_s4: ;
			oscillate1 : apple4_y_in = 10'd284;
			oscillate1_2 : ;
			oscillate2 : apple4_y_in = 10'd276;
			oscillate2_2: ;
		endcase
		
	end
	
	enum logic [2:0] {ready_a2, fall_a2, finish_a2} state_apple2, next_state_apple2;
	logic [9:0] apple2_x_in,apple2_y_in;
	logic [9:0] apple5_x_in,apple5_y_in;
	logic [9:0] apple0_x_in,apple0_y_in;
	logic [9:0] apple1_x_in,apple1_y_in;
	logic [3:0] counter_a2, counter_a2_in;
	always_ff @ (posedge frame_clk)
	begin
		state_apple2 <= next_state_apple2;
		apple2_x <= apple2_x_in;
		apple2_y <= apple2_y_in;
		apple0_x <= apple0_x_in;
		apple0_y <= apple0_y_in;
		apple1_x <= apple1_x_in;
		apple1_y <= apple1_y_in;
		apple5_x <= apple5_x_in;
		apple5_y <= apple5_y_in;
		counter_a2 <= counter_a2_in;
		if(Reset_h)
		begin
			apple2_x <= 10'd259;
			apple2_y <= 10'd142;
			apple5_x <= 10'd472;
			apple5_y <= 10'd280;
			apple0_x <= 10'd3;
			apple0_y <= 10'd142;
			apple1_x <= 10'd131;
			apple1_y <= 10'd142;
			state_apple2 <= ready_a2;
			counter_a2 <= 4'd0;
		end
	end
	parameter [9:0] a2_vspeed = 10'd10;
	parameter [9:0] a2_hspeed = 10'd6;
	parameter [9:0] a5_vspeed = 10'd4;
	parameter [9:0] a5_hspeed = 10'd10;
	parameter [9:0] a1_vspeed = 10'd5;
	parameter [9:0] a1_hspeed = 10'd20;
	parameter [9:0] a0_vspeed = 10'd2;
	parameter [9:0] a0_hspeed = 10'd34;
 	always_comb
	begin
		next_state_apple2 = state_apple2; //default case
		case(state_apple2)
			ready_a2:
				if(Kid_position_X >= 10'd344 && Kid_position_X <= 10'd360 && Kid_position_Y > 10'd138)
					next_state_apple2 = fall_a2;
			fall_a2:
				if(counter_a2 == 4'd15)
					next_state_apple2 = finish_a2;
			finish_a2: ;
		endcase
		//default case
		counter_a2_in = counter_a2;
		apple2_x_in = apple2_x;
		apple2_y_in = apple2_y;
		apple0_x_in = apple0_x;
		apple0_y_in = apple0_y;
		apple1_x_in = apple1_x;
		apple1_y_in = apple1_y;
		apple5_x_in = apple5_x;
		apple5_y_in = apple5_y;
		case(state_apple2)
			ready_a2: ;
			fall_a2:
			begin
				apple2_x_in = apple2_x + a2_hspeed;
				apple2_y_in = apple2_y + a2_vspeed;
				apple5_x_in = apple5_x - a5_hspeed;
				apple5_y_in = apple5_y - a5_vspeed;
				apple1_x_in = apple1_x + a1_hspeed;
				apple1_y_in = apple1_y + a1_vspeed;
				apple0_x_in = apple0_x + a0_hspeed;
				apple0_y_in = apple0_y + a0_vspeed;
				counter_a2_in = counter_a2 + 4'd1;
			end
			finish_a2:
			begin
				apple2_x_in = 10'd700;
				apple2_y_in = 10'd500;
				apple5_x_in = 10'd700;
				apple5_y_in = 10'd500;
				apple1_x_in = 10'd700;
				apple0_x_in = 10'd700;
				apple1_y_in = 10'd500;
				apple0_y_in = 10'd500;
			end
		endcase
	end
	//trap3
		enum logic [2:0] {ready_a6, fall_a6, wait_a6 ,back_a6 ,finish_a6} state_a6, next_state_a6;
		logic [5:0] a6_counter, a6_counter_in;
		logic [9:0] apple6_y_in, apple6_x_in;
		parameter [9:0] a6_vspeed = 10'd8;
		always_ff @ (posedge frame_clk)
		begin
			apple6_y <= apple6_y_in;
			apple6_x <= apple6_x_in;
			a6_counter <= a6_counter_in;
			state_a6 <= next_state_a6;
			if(Reset_h)
			begin
				a6_counter <= 5'd0;
				apple6_y <= 10'd280;
				state_a6 <= ready_a6;
				apple6_x <= 10'd600;
			end		
		end
		
		always_comb
		begin
			next_state_a6 = state_a6;
			case(state_a6)
				ready_a6:
					if(Kid_position_X < 10'd600 && Kid_position_X > 10'd588 && Kid_position_Y > 10'd276)
						next_state_a6 <= fall_a6;
				fall_a6:
					if(a6_counter == 5'd25)
						next_state_a6 <= wait_a6;
				wait_a6:
					if(Kid_position_X <10'd600 && Kid_position_X > 10'd588 && Kid_position_Y > 10'd276)
						next_state_a6 <= back_a6;
				back_a6:
					if(a6_counter == 5'd25)
						next_state_a6 = finish_a6;
				finish_a6: ;
					
			endcase
			
			apple6_x_in = apple6_x;
			apple6_y_in = apple6_y;
			a6_counter_in = a6_counter;
			case(state_a6)
				ready_a6: ;
				fall_a6:
				begin
					a6_counter_in = a6_counter + 5'd1;
					apple6_y_in = apple6_y + a6_vspeed;
					if(a6_counter == 5'd25)
						a6_counter_in = 5'd0;
				end
				wait_a6: ;
				back_a6:
				begin
					a6_counter_in = a6_counter + 5'd1;
					apple6_y_in = apple6_y - a6_vspeed;
					if(a6_counter == 5'd25)
						a6_counter_in = 5'd0;
				end
				finish_a6: ;
			endcase
				
		end
		
	
endmodule

module apple(input logic frame_clk,
			input logic Reset_h,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] PositionX, PositionY,
			input logic [9:0] Kid_position_X, Kid_position_Y,
			output logic isApple,
			output logic [24:0] Apple_address,
			output logic hitApple
			);
	// draw apple
	parameter [9:0] width = 10'd21;
	parameter [9:0] height = 10'd24;
	int radius;
	int start_X,start_Y,end_X,end_Y;
	
	assign start_X = Kid_position_X + 10'd8;
	assign start_Y = Kid_position_Y + 10'd10;
	assign end_X = Kid_position_X + 10'd22;
	assign end_Y = Kid_position_Y + 10'd31;
	
	logic [9:0] DistX, DistY;
	int distX, distY;
	int centerX, centerY;
	int distX2, distY2;
	assign DistX = distX[9:0];
	assign DistY = distY[9:0];
	assign radius = 8;
	enum logic {apple_1, apple_2} curr_state, next_state;
	logic state;
	assign state = curr_state;
	
	logic [4:0] counter, counter_in;
	
	assign distX = DrawX - PositionX;
	assign distY = DrawY - PositionY;
	assign centerX = PositionX + 10;
	assign centerY = PositionY + 12;
	assign distX2 = centerX - DrawX;
	assign distY2 = centerY - DrawY;
	logic [9:0] point1_X,point2_X,point3_X,point4_X,point5_X,point6_X,point7_X,point8_X;
	logic [9:0] point1_Y,point2_Y,point3_Y,point4_Y,point5_Y,point6_Y,point7_Y,point8_Y;
	logic hit1,hit2,hit3,hit4,hit5,hit6,hit7,hit8;
	assign point1_X = PositionX + 10'd10;
	assign point1_Y = PositionY + 10'd4;
	assign point2_X = PositionX + 10'd10;
	assign point2_Y = PositionY + 10'd20;
	assign point3_X = PositionX + 10'd2;
	assign point3_Y = PositionY + 10'd12;
	assign point4_X = PositionX + 10'd18;
	assign point4_Y = PositionY + 10'd12;
	assign point5_X = PositionX + 10'd4;
	assign point5_Y = PositionY + 10'd16;
	assign point6_X = PositionX + 10'd16;
	assign point6_Y = PositionY + 10'd16;
	assign point7_X = PositionX + 10'd4;
	assign point7_Y = PositionY + 10'd8;
	assign point8_X = PositionX + 10'd16;
	assign point8_Y = PositionY + 10'd8;
	
	assign hit1 = (point1_X >= start_X) && (point1_X <= end_X) && (point1_Y >= start_Y) && (point1_Y <= end_Y);
	assign hit2 = (point2_X >= start_X) && (point2_X <= end_X) && (point2_Y >= start_Y) && (point2_Y <= end_Y);
	assign hit3 = (point3_X >= start_X) && (point3_X <= end_X) && (point3_Y >= start_Y) && (point3_Y <= end_Y);
	assign hit4 = (point4_X >= start_X) && (point4_X <= end_X) && (point4_Y >= start_Y) && (point4_Y <= end_Y);
	assign hit5 = (point5_X >= start_X) && (point5_X <= end_X) && (point5_Y >= start_Y) && (point5_Y <= end_Y);
	assign hit6 = (point6_X >= start_X) && (point6_X <= end_X) && (point6_Y >= start_Y) && (point6_Y <= end_Y);
	assign hit7 = (point7_X >= start_X) && (point7_X <= end_X) && (point7_Y >= start_Y) && (point7_Y <= end_Y);
	assign hit8 = (point8_X >= start_X) && (point8_X <= end_X) && (point8_Y >= start_Y) && (point8_Y <= end_Y);
	AppleAddress AA(.*);
	
	always_ff @(posedge frame_clk) begin
		if(Reset_h) begin
			curr_state <= apple_1;
			counter <= 5'd0;
		end
		counter <= counter_in;
		curr_state <= next_state;
	end
	
	always_comb begin
		counter_in = counter + 5'd1;
		next_state = curr_state;
		if(counter >= 5'd30) begin	
			unique case(curr_state)
				apple_1:
					next_state = apple_2;
				apple_2:
					next_state = apple_1;
			endcase
			counter_in = 5'd0;
		end
	end
	
	// draw apple
	always_comb begin
		if((distX2 * distX2) + (distY2* distY2) <= radius*radius)
			isApple = 1'b1;
		else
			isApple = 1'b0;
	end
	
	always_comb begin
		if( hit1 | hit2 | hit3 | hit4 | hit5 | hit6 | hit7 | hit8 )
			hitApple = 1'b1;
		else
			hitApple = 1'b0;
	end
	
endmodule



module AppleAddress(input logic [9:0] DistX, DistY,
					input logic isApple,
					input logic state,
					output logic [24:0] Apple_address);
	
	int posX, posY, offset, image_offset;
	always_comb begin
		posX = DistX;
		posY = DistY;
		offset = posX + posY*21;
		// 15360 = 14336 + 1024 ==> right after Spur in the memory
		image_offset = offset + state * 1024 + 15360;
		if(~isApple)
			Apple_address = 25'd0;
		else
			Apple_address = image_offset[24:0];
	end


endmodule

