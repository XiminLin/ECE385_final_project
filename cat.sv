module cat(input logic frame_clk,
			input logic Reset_h,
			input logic [9:0] Bullet_position_X, Bullet_position_Y,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] Kid_position_X, Kid_position_Y,
//			output logic [9:0] Cat_position_X, Cat_position_Y,
			output logic [24:0] Cat_address,
			output logic hitBullet,
			output logic isCat,
			output logic hitCat);
	
	logic hitCat_in;
	logic hitBullet_in;
	

	
	logic [9:0] PositionX, PositionY;
	logic [9:0] PositionX_in, PositionY_in;
	
	parameter [9:0] width = 10'd320;
	parameter [9:0] height = 10'd131;
	
	enum logic [2:0] {prepare,wait_1,wait_2,wait_3, rush, dead} curr_state, next_state;
	
	parameter [9:0] initial_X = 10'd550;
	
	
	int DistX, DistY, offset, image_off;
	
	parameter [9:0] trigger_X = 10'd350;
	
	always_ff @ (posedge frame_clk) begin
		if(Reset_h) begin
			curr_state <= prepare;
			PositionX <= initial_X;
			PositionY <= 10'd6;
			hitCat <= 1'b0;
			hitBullet <= 1'b0;
		end
		else begin
			curr_state <= next_state;
			PositionX <= PositionX_in;
			PositionY <= PositionY_in;
			hitCat <= hitCat_in;
			hitBullet <= hitBullet_in;
		end
	end
	
	
	always_comb begin

		next_state = curr_state;
		case(curr_state)
			prepare:
				if(Kid_position_X >= trigger_X && Kid_position_Y < 10'd170)
					next_state = wait_1;
			wait_1:
				next_state = wait_2;
			wait_2:
				next_state = wait_3;
			wait_3:
				next_state = rush;
			rush: 
				if(hitBullet == 1'b1)
					next_state = dead;
			dead: ;
				
		endcase
		PositionX_in = PositionX;
		PositionY_in = PositionY;
		isCat = 1'b0;
		hitCat_in = 1'b0;
		hitBullet_in = 1'b0;
		Cat_address = 25'd0;
		DistX = DrawX - PositionX;
		DistY = DrawY - PositionY;
		offset = DistX + DistY * width + 18432;
		case(curr_state)
			prepare: ;
			
			wait_1: 
			begin
				if(DrawX >= PositionX && DrawX <= PositionX + width && DrawY >= PositionY && DrawY <= PositionY + height) begin
					isCat = 1'b1;
					Cat_address = offset[24:0];
				end
			end
			wait_2:
			begin
				if(DrawX >= PositionX && DrawX <= PositionX + width && DrawY >= PositionY && DrawY <= PositionY + height) begin
					isCat = 1'b1;
					Cat_address = offset[24:0];
				end
			end
			wait_3:
			begin
				if(DrawX >= PositionX && DrawX <= PositionX + width && DrawY >= PositionY  && DrawY <= PositionY + height) begin
					isCat = 1'b1;
					Cat_address = offset[24:0];
				end
			end
			rush: 
			begin
				if(DrawX >= PositionX && DrawX <= PositionX + width && DrawY >= PositionY && DrawY <= PositionY + height) begin
					isCat = 1'b1;
					Cat_address = offset[24:0];
				end
				if(Kid_position_X + 10'd32 >= PositionX && Kid_position_X <= PositionX + width) begin
					hitCat_in = 1'b1;
				end
				PositionX_in = PositionX - 10'd5;
				PositionY_in = PositionY;
				if(PositionX < 10'd2)
					PositionX_in = 10'd0;
				if(Bullet_position_X >= PositionX && Bullet_position_Y >= PositionY && Bullet_position_Y <= PositionY + height) 
					hitBullet_in = 1'b1;
			end
			dead: ;
		endcase
		end
//			if(DrawX >= PositionX + 10'd20 && DrawX <= PositionX + width && 
//												DrawY >= PositionY + 10'd100 && DrawY <= PositionY + height) begin
//				isCat_in = 1'b1;
//				Cat_address_in = offset[24:0];
//			end
//			
//			if(DrawX >= PositionX + 10'd10 && DrawX <= PositionX + width &&
//												DrawY >= PositionY + 10'd35 && DrawY < PositionY + 10'd100) begin
//				isCat_in = 1'b1;
//				Cat_address_in = offset[24:0];
//			end
//			
//			if(DrawX >= PositionX + 10'd35 && DrawX <= PositionX + width &&
//												DrawY >= PositionY && DrawY < PositionY + 10'd35) begin
//				isCat_in = 1'b1;
//				Cat_address_in = offset[24:0];
//			end	
//			
//			if(Kid_position_X + 10'd20 >= PositionX + 10'd20 && Kid_position_X <= PositionX + width && 
//												Kid_position_Y >= PositionY + 10'd100 && Kid_position_Y <= PositionY + height) begin
//				hitCat_in = 1'b1;
//			end
//			
//			if(Kid_position_X + 10'd32 >= PositionX + 10'd10 && Kid_position_X <= PositionX + width &&
//												Kid_position_Y >= PositionY + 10'd35 && Kid_position_Y < PositionY + 10'd100) begin
//				hitCat_in = 1'b1;
//			end
//			
//			if(Kid_position_X + 10'd32 >= PositionX + 10'd35 && Kid_position_X <= PositionX + width &&
//												Kid_position_Y >= PositionY && Kid_position_Y < PositionY + 10'd35) begin
//				hitCat_in = 1'b1;
//			end
			
//			if(Bullet_position_X >= PositionX && Bullet_position_Y >= PositionY && Bullet_position_Y <= PositionY + height) begin
//				hitBullet_in = 1'b1;
//				life_in = life - 1;
//			end
//			if(life == 0) begin
//				life_in = 0;
//				next_state = dead;
//			end
//			if(Kid_position_X >= trigger_X && Kid_position_Y >= PositionY && Kid_position_Y <= PositionY + height) begin
//				next_state = rush;
//			end
//		end
//		
//		rush: begin
//			if(Kid_position_X + 10'd32 >= PositionX && Kid_position_X <= PositionX + width && 
//												Kid_position_Y >= PositionY && Kid_position_Y <= PositionY + height) begin
//				hitCat_in = 1'b1;
//			end
//		
//			if(DrawX >= PositionX && DrawX < PositionX + width && DrawY >= PositionY && DrawY < PositionY + height) begin
//				isCat_in = 1'b1;
//				Cat_address_in = offset[24:0];
//			end
//			
//			PositionX_in = PositionX - 10'd8;
//			PositionY_in = PositionY;
//			if(PositionX > initial_X) begin
//				next_state = prepare;
//				PositionX_in = initial_X;
//			end
//		end
//		
//		dead: ;
////		dead: begin
////			isCat_in = 1'b0;
////			Cat_address_in = 25'd0;
////			hitCat_in = 1'b0;
////		end
//		
//		endcase
			
//	assign Cat_position_X = PositionX;
//	assign Cat_position_Y = PositionY;
	
endmodule

