module allSpur(input logic Reset_h,
				input logic frame_clk,
				input logic [9:0] DrawX, DrawY,
				input logic [9:0] Kid_position_X, Kid_position_Y,
				output logic [24:0] Spur_address,
				output logic isSpur,
				output logic hitSpur
				);
				
	parameter [9:0] spur0_X = 10'd96;
	parameter [9:0] spur0_Y = 10'd106;
	
	parameter [9:0] spur1_X = 10'd160;
	parameter [9:0] spur1_Y = 10'd106;
	
	parameter [9:0] spur2_X = 10'd224;
	parameter [9:0] spur2_Y = 10'd106;
	
	parameter [9:0] spur4_X = 10'd320;
	parameter [9:0] spur4_Y = 10'd135;
 	
	parameter [9:0] spur5_X = 10'd450;
	parameter [9:0] spur5_Y = 10'd244;
	
	logic [9:0] s6_X,s7_X,s8_X,s9_X,s10_X;
	logic [9:0] s6_Y,s7_Y,s8_Y,s9_Y,s10_Y;
	
	logic [9:0] s11_X,s12_X,s11_Y,s12_Y;
	logic [9:0] s13_X,s13_Y;
	
	parameter [9:0] h_speed = 10'd4;

	logic [9:0] s3_X,s3_Y,s3_X_in; //s3 will be a trap that can move horizontally
	logic [1:0] counter_s3, counter_s3_in; //it will count to 3
	logic [2:0] step_s3, step_s3_in; //another counter
	logic s3_out,s3_out_in;
	assign s3_Y = 10'd106;
	enum logic [2:0] {ready, forward, wait1,wait2,wait3 ,back, finish} state_s3, next_state_s3;
	
	assign s7_X = s6_X + 10'd32;
	assign s8_X = s7_X + 10'd32;
	assign s9_X = s8_X + 10'd32;
	assign s10_X = s9_X + 10'd32;
	

	assign s7_Y = s6_Y;
	assign s8_Y = s7_Y;
	assign s9_Y = s8_Y;
	assign s10_Y = s9_Y;
	
	assign s11_Y = 10'd416;
	assign s12_Y = 10'd416;
	
	logic hitSpur0, hitSpur1, hitSpur2, hitSpur3, hitSpur4,hitSpur5,hitSpur6,hitSpur7,hitSpur8,hitSpur9,hitSpur10,hitSpur11,hitSpur12,hitSpur13;
	logic [24:0] Spur_address0, Spur_address1, Spur_address2, Spur_address3, Spur_address4,Spur_address5,Spur_address6,Spur_address7,Spur_address8,Spur_address9,Spur_address10,Spur_address11,Spur_address12,Spur_address13;	
	logic isSpur0, isSpur1, isSpur2, isSpur3, isSpur4,isSpur5,isSpur6,isSpur7,isSpur8,isSpur9,isSpur10,isSpur11,isSpur12,isSpur13;
	assign s13_X = 10'd420;
	assign s13_Y = 10'd170;
	Spur s0(.*, .PositionX(spur0_X), .PositionY(spur0_Y), .isSpur(isSpur0), .Spur_address(Spur_address0), .hitSpur(hitSpur0) );
	Spur s1(.*, .PositionX(spur1_X), .PositionY(spur1_Y), .isSpur(isSpur1), .Spur_address(Spur_address1), .hitSpur(hitSpur1) );
	Spur s2(.*, .PositionX(spur2_X), .PositionY(spur2_Y), .isSpur(isSpur2), .Spur_address(Spur_address2), .hitSpur(hitSpur2) );
	Spur s3(.*, .PositionX(s3_X), .PositionY(s3_Y), .isSpur(isSpur3), .Spur_address(Spur_address3), .hitSpur(hitSpur3));
	Spur s4(.*, .PositionX(spur4_X), .PositionY(spur4_Y), .isSpur(isSpur4), .Spur_address(Spur_address4), .hitSpur(hitSpur4) );
	Spur s5(.*, .PositionX(spur5_X), .PositionY(spur5_Y), .isSpur(isSpur5), .Spur_address(Spur_address5), .hitSpur(hitSpur5) );
	Spur s6(.*, .PositionX(s6_X), .PositionY(s6_Y), .isSpur(isSpur6), .Spur_address(Spur_address6), .hitSpur(hitSpur6) );
	Spur s7(.*, .PositionX(s7_X), .PositionY(s7_Y), .isSpur(isSpur7), .Spur_address(Spur_address7), .hitSpur(hitSpur7) );
	Spur s8(.*, .PositionX(s8_X), .PositionY(s8_Y), .isSpur(isSpur8), .Spur_address(Spur_address8), .hitSpur(hitSpur8) );
	Spur s9(.*, .PositionX(s9_X), .PositionY(s9_Y), .isSpur(isSpur9), .Spur_address(Spur_address9), .hitSpur(hitSpur9) );
	Spur s10(.*, .PositionX(s10_X), .PositionY(s10_Y), .isSpur(isSpur10), .Spur_address(Spur_address10), .hitSpur(hitSpur10));
	Spur s11(.*, .PositionX(s11_X), .PositionY(s11_Y), .isSpur(isSpur11), .Spur_address(Spur_address11), .hitSpur(hitSpur11));
	Spur s12(.*, .PositionX(s12_X), .PositionY(s12_Y), .isSpur(isSpur12), .Spur_address(Spur_address12), .hitSpur(hitSpur12));
	Inv_Spur s13(.*, .PositionX(s13_X), .PositionY(s13_Y), .isSpur(isSpur13), .Spur_address(Spur_address13), .hitSpur(hitSpur13));
	assign isSpur = isSpur0 | isSpur1 | isSpur2 | isSpur3 | isSpur4 | isSpur5 | isSpur6 | isSpur7 | isSpur8 | isSpur9 | isSpur10 | isSpur11 | isSpur12 | isSpur13;
	assign Spur_address = Spur_address0 | Spur_address1 | Spur_address2 | Spur_address3 | Spur_address4 | Spur_address5 | Spur_address6 | Spur_address7 | Spur_address8 | Spur_address9 | Spur_address10 | Spur_address11 | Spur_address12 | Spur_address13;
	assign hitSpur = hitSpur0 | hitSpur1 | hitSpur2 | hitSpur3 | hitSpur4 | hitSpur5 | hitSpur6 | hitSpur7 | hitSpur8 | hitSpur9 | hitSpur10 | hitSpur11 | hitSpur12 | hitSpur13;
	
	logic [2:0] counter_s3_wait, counter_s3_wait_in;
	//trap1
	always_ff @ (posedge frame_clk)
	begin
		s3_X <= s3_X_in; //default case
		state_s3 <= next_state_s3;
		counter_s3 <= counter_s3_in;
		step_s3 <= step_s3_in;
		s3_out <= s3_out_in;
		counter_s3_wait <= counter_s3_wait_in;
		if(Reset_h)
		begin
			state_s3 <= ready;
			counter_s3 <= 2'd0;
			step_s3 <= 3'd0;
			s3_X <= 10'd288;
			s3_out <= 1'b1;
			counter_s3_wait <= 3'd0;
		end
	end
	
	
	always_comb
	begin
		next_state_s3 = state_s3;
		case(state_s3)
			ready:
				if(Kid_position_X > 10'd222 && s3_out == 1'b1 && Kid_position_Y < 10'd106)
					next_state_s3 = forward;
			forward:
				if(step_s3 == 3'd7)
					next_state_s3 = wait1;
			wait1:
				if(counter_s3_wait == 3'd4)
					next_state_s3 = wait2;
			wait2:
				next_state_s3 = wait3;
			wait3:
				next_state_s3 = back;
			back:
			begin
				if(step_s3 == 3'd7 && counter_s3 == 2'd3)
					next_state_s3 = finish;
				else if(step_s3 == 3'd7)
					next_state_s3 = ready;
			end
			finish: ;
		endcase
		//default case 
		s3_X_in = s3_X;
		counter_s3_in = counter_s3;
		step_s3_in = step_s3;
		s3_out_in = s3_out;
		counter_s3_wait_in = counter_s3_wait;
		case(state_s3)
			ready:
			begin
				s3_X_in = 10'd288;
				step_s3_in = 2'd0;
				if(Kid_position_X < 10'd222)
					s3_out_in = 1'b1;
				if(Kid_position_X > 10'd222)
				begin
					counter_s3_in = counter_s3 + 2'd1;
					s3_out_in = 1'b0;
				end
			end
			forward:
			begin
				s3_X_in = s3_X - h_speed;
				step_s3_in = step_s3 + 3'd1;
			end
			wait1: 
				counter_s3_wait_in = counter_s3_wait + 3'd1;
			wait2: 
				counter_s3_wait_in = 3'd0;
			wait3: ;
			back:
			begin
				s3_X_in = s3_X + h_speed;
				step_s3_in = step_s3 + 3'd1;
			end
			finish: 
				s3_X_in = 10'd288;
				
		endcase
		
	end
	//trap 2
	enum logic [2:0] {ready_s6,up_s6,upwait_s6,forward_s6,back_s6,final_s6} state_s6, next_state_s6;
	parameter [9:0] s6_upspeed = 10'd2;
	parameter [9:0] s6_hspeed = 10'd6;
	logic [9:0] s6_X_in, s6_Y_in;
	logic [3:0] s6_upcounter, s6_upcounter_in;
	logic [3:0] s6_hcounter, s6_hcounter_in;
	always_ff @ (posedge frame_clk)
	begin
		state_s6 <= next_state_s6;
		s6_X <= s6_X_in;
		s6_Y <= s6_Y_in;
		s6_upcounter <= s6_upcounter_in;
		s6_hcounter <= s6_hcounter_in;
		if(Reset_h)
		begin
			state_s6 <= ready_s6;
			s6_X <= 10'd32;
			s6_Y <= 10'd448;
			s6_upcounter <= 4'd0;
			s6_hcounter <= 4'd0;
		end
	end
	
	always_comb
	begin
		next_state_s6 = state_s6; //default case
		case(state_s6)
			ready_s6:
			begin
				if(Kid_position_X >= 10'd32 && Kid_position_X <= 10'd192 && Kid_position_Y > 10'd300)
					next_state_s6 = up_s6;
			end
			up_s6:
			begin
				if(s6_upcounter == 4'd15)
					next_state_s6 = upwait_s6;
			end
			upwait_s6:
			begin
				if(Kid_position_X >= 10'd192 && Kid_position_Y == 10'd416)
					next_state_s6 = forward_s6;
			end
			forward_s6:
			begin
				if(s6_hcounter == 4'd15)
					next_state_s6 = back_s6;
			end
			back_s6:
			begin
				if(s6_hcounter == 4'd15)
					next_state_s6 = final_s6;
			end
			final_s6: ;
		
		endcase
		//default cases
		s6_X_in = s6_X;
		s6_Y_in = s6_Y;
		s6_upcounter_in = s6_upcounter;
		s6_hcounter_in = s6_hcounter;
		case(state_s6)
			ready_s6:
			begin
				s6_upcounter_in = 4'd0;
				s6_hcounter_in = 4'd0;
			end
			up_s6:
			begin
				s6_upcounter_in = s6_upcounter + 4'd1;
				s6_Y_in = s6_Y - s6_upspeed;
				if(s6_upcounter == 4'd15)
					s6_upcounter_in = 4'd0;
			end
			upwait_s6: ;
			forward_s6:
			begin
				s6_hcounter_in = s6_hcounter + 4'd1;
				s6_X_in = s6_X + s6_hspeed;
				if(s6_hcounter == 4'd15)
					s6_hcounter_in = 4'd0;
			end
			back_s6:
			begin
				s6_hcounter_in = s6_hcounter + 4'd1;
				s6_X_in = s6_X - s6_hspeed;
				if(s6_hcounter == 4'd15)
					s6_hcounter_in = 4'd0;
			end
			final_s6: ;
		
		endcase
		
		end
		//trap 3
		parameter [9:0] low_speed = 10'd4;
		parameter [9:0] high_speed = 10'd8;
		logic [9:0] s11_X_in, s12_X_in;
		enum logic [3:0] {reset_s11,forward_s11,back_s11,forward_s11_fast,back_s11_fast} state_s11, next_state_s11;
		logic [3:0] shift_counter, shift_counter_in;
		logic [2:0] shift_counter_faster, shift_counter_faster_in;
		always_ff @ (posedge frame_clk)
		begin
			state_s11 <= next_state_s11;
			s11_X <= s11_X_in;
			s12_X <= s12_X_in;
			shift_counter <= shift_counter_in;
			shift_counter_faster <= shift_counter_faster_in;
			if(Reset_h)
			begin
				state_s11 <= reset_s11;
				s11_X <= 10'd256;
				shift_counter <= 4'd0;
				shift_counter_faster <= 3'd0;
				s12_X <= 10'd416;
			end
		end
		
		always_comb
		begin
			next_state_s11 = state_s11; //default case
			case(state_s11)
				reset_s11:
					next_state_s11 = forward_s11;
				forward_s11:
				begin
					if(shift_counter == 4'd15 && Kid_position_X >= 10'd288 && Kid_position_X <= 10'd416 && Kid_position_Y > 10'd300)
						next_state_s11 = back_s11_fast;
					else if(shift_counter == 4'd15)
						next_state_s11 = back_s11;
				end
				back_s11:
				begin
					if(shift_counter == 4'd15 && Kid_position_X >= 10'd288 && Kid_position_X <= 10'd416 && Kid_position_Y > 10'd300)
						next_state_s11 = forward_s11_fast;
					else if(shift_counter == 4'd15)
						next_state_s11 = forward_s11;
				end
				forward_s11_fast:
				begin
					if(shift_counter_faster == 3'd7)
						next_state_s11 = back_s11_fast;
				end
				back_s11_fast:
				begin
					if(shift_counter_faster == 3'd7)
						next_state_s11 = forward_s11_fast;
				end
			endcase
			
			shift_counter_in = shift_counter; //default case
			s11_X_in = s11_X;
			s12_X_in = s12_X;
			shift_counter_faster_in = shift_counter_faster;
			case(state_s11)
			reset_s11: ;
			forward_s11:
			begin
				shift_counter_in = shift_counter + 4'd1;
				s11_X_in = s11_X + low_speed;
				s12_X_in = s12_X - low_speed;
			end
			back_s11:
			begin
				shift_counter_in = shift_counter + 4'd1;
				s11_X_in = s11_X - low_speed;
				s12_X_in = s12_X + low_speed;
			end
			forward_s11_fast:
			begin
				shift_counter_faster_in = shift_counter_faster + 3'd1;
				s11_X_in = s11_X + high_speed;
				s12_X_in = s12_X - high_speed;
			end
			back_s11_fast:
			begin
				shift_counter_faster_in = shift_counter_faster + 3'd1;
				s11_X_in = s11_X - high_speed;
				s12_X_in = s12_X + high_speed;
			end
			endcase 
		end
	
endmodule

module Inv_Spur(
		input logic Reset_h,
		input logic [9:0] PositionX,
		input logic [9:0] Kid_position_X, Kid_position_Y,
		input logic [9:0] PositionY,
		input logic [9:0] DrawX, DrawY,
		output logic [24:0] Spur_address,
		output logic isSpur,
		output logic hitSpur
);

	logic [9:0] DistX, DistY;
	logic [9:0] end_X, end_Y;
	logic [9:0] start_X, start_Y;
	parameter [9:0] width = 10'd32;
	parameter [9:0] height = 10'd32;
	logic [9:0] pointX_1, pointX_2, pointX_3, pointX_4, pointX_5, pointX_6;
	logic [9:0] pointY_1, pointY_2, pointY_3, pointY_4, pointY_5, pointY_6;
	logic [9:0] DistX2, DistX3, DistY2;
	assign pointX_1 = PositionX + 10'd15;
	assign pointX_2 = PositionX + 10'd8;
	assign pointX_3 = PositionX + 10'd24;
	assign pointX_4 = PositionX;
	assign pointX_5 = PositionX + 10'd15;
	assign pointX_6 = PositionX + 10'd31;
	assign pointY_1 = PositionY + 10'd31;
	assign pointY_2 = PositionY + 10'd15;
	assign pointY_3 = pointY_2;
	assign pointY_4 = PositionY;
	assign pointY_5 = pointY_4;
	assign pointY_6 = pointY_5;
	
	assign DistX = DrawX - PositionX;
	assign DistY = DrawY - PositionY;
	assign DistY2 = DrawY - PositionY;
	assign start_X = Kid_position_X + 10'd8;
	assign start_Y = Kid_position_Y + 10'd10;
	assign end_X = Kid_position_X + 10'd22;
	assign end_Y = Kid_position_Y + 10'd31;
	assign DistX2 = DistX + DistX;
	assign DistX3 = (PositionX + 10'd31 - DrawX) + (PositionX + 10'd31 - DrawX);
	logic hit1,hit2,hit3,hit4,hit5,hit6;
	assign hit1 = (pointX_1 >= start_X) && (pointX_1 <= end_X) && (pointY_1 >= start_Y) && (pointY_1 <= end_Y);
	assign hit2 = (pointX_2 >= start_X) && (pointX_2 <= end_X) && (pointY_2 >= start_Y) && (pointY_2 <= end_Y);	
	assign hit3 = (pointX_3 >= start_X) && (pointX_3 <= end_X) && (pointY_3 >= start_Y) && (pointY_3 <= end_Y);
	assign hit4 = (pointX_4 >= start_X) && (pointX_4 <= end_X) && (pointY_4 >= start_Y) && (pointY_4 <= end_Y);
	assign hit5 = (pointX_5 >= start_X) && (pointX_5 <= end_X) && (pointY_5 >= start_Y) && (pointY_5 <= end_Y);
	assign hit6 = (pointX_6 >= start_X) && (pointX_6 <= end_X) && (pointY_6 >= start_Y) && (pointY_6 <= end_Y);	
	always_comb begin
		if(DistX >= 0 && DistY >= 0 && DistX < width && DistY < height && (((DistY2 <= DistX2) && (DistX < 10'd16)) || ((DistY2 <= DistX3) && (DistX >= 10'd16))))
			isSpur = 1'b1;
		else
			isSpur = 1'b0;
	end
	always_comb begin
		if( hit1 | hit2 | hit3 | hit4 | hit5 | hit6 )
			hitSpur = 1'b1;
		else
			hitSpur = 1'b0;
	end
	inv_SpurAddress SA0(.*);
endmodule 

module inv_SpurAddress(input logic [9:0] DistX, DistY,
					input logic isSpur,
					output logic [24:0] Spur_address);
	
	int pos_x, pos_y, offset;
 	
	always_comb begin
		pos_x = DistX;
		pos_y = DistY;
		offset = pos_x + pos_y * 32 + 17408;
		if(~isSpur) begin
			Spur_address = 25'd0;
		end
		// 14336 =  1024 * 2 * 7 ==> right after the kid pictures in the memory
		else begin
			Spur_address = offset[24:0]; 		
		end
	end


endmodule
module Spur(input logic Reset_h,
			input logic [9:0] PositionX,
			input logic [9:0] PositionY,
			input logic [9:0] Kid_position_X, Kid_position_Y,
 			input logic [9:0] DrawX, DrawY,
			output logic [24:0] Spur_address,
			output logic isSpur,
			output logic hitSpur
			);
			
	logic [9:0] DistX, DistY;
	logic [9:0] end_X, end_Y;
	logic [9:0] start_X, start_Y;
	parameter [9:0] width = 10'd32;
	parameter [9:0] height = 10'd32;
	logic [9:0] pointX_1, pointX_2, pointX_3, pointX_4, pointX_5, pointX_6;
	logic [9:0] pointY_1, pointY_2, pointY_3, pointY_4, pointY_5, pointY_6;
	logic [9:0] DistX2, DistX3, DistY2;
	assign pointX_1 = PositionX + 10'd15;
	assign pointX_2 = PositionX + 10'd8;
	assign pointX_3 = PositionX + 10'd24;
	assign pointX_4 = PositionX;
	assign pointX_5 = PositionX + 10'd15;
	assign pointX_6 = PositionX + 10'd31;
	assign pointY_1 = PositionY;
	assign pointY_2 = PositionY + 10'd15;
	assign pointY_3 = pointY_2;
	assign pointY_4 = PositionY + 10'd31;
	assign pointY_5 = pointY_4;
	assign pointY_6 = pointY_5;
	
	assign DistX = DrawX - PositionX;
	assign DistY = DrawY - PositionY;
	assign DistY2 = PositionY + 10'd32 - DrawY;
	assign start_X = Kid_position_X + 10'd8;
	assign start_Y = Kid_position_Y + 10'd10;
	assign end_X = Kid_position_X + 10'd22;
	assign end_Y = Kid_position_Y + 10'd31;
	assign DistX2 = DistX + DistX;
	assign DistX3 = (PositionX + 10'd31 - DrawX) + (PositionX + 10'd31 - DrawX);
	logic hit1,hit2,hit3,hit4,hit5,hit6;
	assign hit1 = (pointX_1 >= start_X) && (pointX_1 <= end_X) && (pointY_1 >= start_Y) && (pointY_1 <= end_Y);
	assign hit2 = (pointX_2 >= start_X) && (pointX_2 <= end_X) && (pointY_2 >= start_Y) && (pointY_2 <= end_Y);	
	assign hit3 = (pointX_3 >= start_X) && (pointX_3 <= end_X) && (pointY_3 >= start_Y) && (pointY_3 <= end_Y);
	assign hit4 = (pointX_4 >= start_X) && (pointX_4 <= end_X) && (pointY_4 >= start_Y) && (pointY_4 <= end_Y);
	assign hit5 = (pointX_5 >= start_X) && (pointX_5 <= end_X) && (pointY_5 >= start_Y) && (pointY_5 <= end_Y);
	assign hit6 = (pointX_6 >= start_X) && (pointX_6 <= end_X) && (pointY_6 >= start_Y) && (pointY_6 <= end_Y);	
	always_comb begin
		if(DistX >= 0 && DistY >= 0 && DistX < width && DistY < height && (((DistY2 <= DistX2) && (DistX < 10'd16)) || ((DistY2 <= DistX3) && (DistX >= 10'd16))))
			isSpur = 1'b1;
		else
			isSpur = 1'b0;
	end
	
	always_comb begin
		if( hit1 | hit2 | hit3 | hit4 | hit5 | hit6 )
			hitSpur = 1'b1;
		else
			hitSpur = 1'b0;
	end
	
	SpurAddress SA0(.*);
	
endmodule


module SpurAddress(input logic [9:0] DistX, DistY,
					input logic isSpur,
					output logic [24:0] Spur_address);
	
	int pos_x, pos_y, offset;
 	
	always_comb begin
		pos_x = DistX;
		pos_y = DistY;
		offset = pos_x + pos_y * 32 + 14336;
		if(~isSpur) begin
			Spur_address = 25'd0;
		end
		// 14336 =  1024 * 2 * 7 ==> right after the kid pictures in the memory
		else begin
			Spur_address = offset[24:0]; 		
		end
	end


endmodule

