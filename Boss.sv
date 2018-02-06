module Boss(input logic frame_clk,
//			input logic Clock_50,
			input logic Reset_h,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] Kid_position_X, Kid_position_Y,
			input logic [9:0] bullet_X, bullet_Y,
			input logic NoBomb,
			output logic [24:0] Boss_address,
			output logic shoot,
			output logic isBoss,
			output logic hitBoss,
			output logic Boss_dead,
			output logic [9:0] Boss_position_X, Boss_position_Y
			);
			
	logic [9:0] PositionX, PositionY;
	logic [9:0] PositionX_in, PositionY_in;
	logic [9:0] MovementY, MovementY_in;
	logic [9:0] MovementX, MovementX_in;
	logic hitBullet;
	
	logic hitBoss_in;
	logic isBoss_in;
	logic [24:0] Boss_address_in;
	
	// 0 --- left; 1 --- right
	logic direction;
	int wudi_counter, wudi_counter_in;
	logic blink;
	
	int bigger_counter, bigger_counter_in;
	
	int KB_X, KB_Y;
	
	int DistX, DistY, Size0, Size1, offset;
	logic [9:0] rush_counter, rush_counter_in;
	
	parameter int Dist_bigger = 100;
	
	parameter [9:0] triggerY_redBomb = 10'd400;		// second layer
	parameter [9:0] triggerY_jump = 10'd350;		// third layer
	
	enum logic [3:0] {living, bigger, prepareBomb, sendBomb, jump, rush, rush_back, fall, fall_hurt, fall_big, wudi, dead} curr_state, next_state;

	parameter [9:0] half_width = 10'd32;
	parameter [9:0] half_height = 10'd32;
	
	parameter [9:0] bigger_half_width = 10'd64;
	parameter [9:0] bigger_half_height = 10'd64;
	
	assign Boss_position_X = PositionX;
	assign Boss_position_Y = PositionY;
	
	int life, life_in;
	
//	always_ff @ (posedge Clock_50) begin
//		if(Reset_h) begin
//			isBoss <= 1'b0;
//			Boss_address <= 25'd0;
//		end
//		else begin
//			isBoss <= isBoss_in;
//			Boss_address <= Boss_address_in;
//		end
//	end
//
//	assign isBoss = isBoss_in;
//	assign Boss_address = Boss_address_in;
	
	always_ff @ (posedge frame_clk) begin
		if(Reset_h) begin
			PositionX <= 10'd607;
			PositionY <= 10'd416;
			life <= 10;
			rush_counter <= 10'd0;
			wudi_counter <= 0;
			curr_state <= living;
			direction <= 1'b0;
			blink <= 1'b0;
			bigger_counter <= 0;
			hitBoss <= 1'b0; 
			MovementY <= 10'd0;
			MovementX <= 10'd0;
		end
		else begin
			PositionX <= PositionX_in;
			PositionY <= PositionY_in;
			life <= life_in;
			rush_counter <= rush_counter_in;
			bigger_counter <= bigger_counter_in;
			wudi_counter <= wudi_counter_in;
			curr_state <= next_state;
			direction <= 1'b0;
			blink <= ~blink;
			hitBoss <= hitBoss_in;
			MovementY <= MovementY_in;
			MovementX <= MovementX_in;
		end
	end
	
	bullet_hit bl0(.*);
	
	always_comb begin
		Size0 = half_width;
		Size1 = bigger_half_width;
		PositionX_in = PositionX;
		PositionY_in = PositionY;
		Boss_dead = 1'b0;
		next_state = curr_state;
		rush_counter_in = 10'd4;
		bigger_counter_in = bigger_counter;
		wudi_counter_in = wudi_counter;
		MovementY_in = MovementY;
		MovementX_in = MovementX;
		life_in = life;
		shoot = 1'b0;
		isBoss = 1'b0;
		hitBoss_in = 1'b0;
		Boss_address = 25'd0;
		DistX = DrawX - PositionX;
		DistY = DrawY - PositionY;
		KB_X = Kid_position_X + 16 - PositionX;
		KB_Y = Kid_position_Y + 16 - PositionY;
		offset = DistX*2 + DistY*256 + 68479;
		if( DistX*DistX + DistY*DistY <= Size0*Size0) begin
			isBoss = 1'b1;
			Boss_address = offset[24:0];
		end
		
		if( KB_X*KB_X + KB_Y*KB_Y <= Size0*Size0 ) begin
			hitBoss_in = 1'b1;
		end
		
		case(curr_state)
		
			living: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				
				// fall
				else if(Kid_position_Y + 10'd15 > PositionY) begin
					MovementY_in = 10'd20;
					next_state = fall;
				end
 				
				// jump
				else if( Kid_position_Y + 10'd15 <= triggerY_jump) begin
					MovementY_in = ~(10'd20) + 10'd1;
					next_state = jump;
				end
				
				// make bigger
				else if( KB_X*KB_X + KB_Y*KB_Y <= Dist_bigger*Dist_bigger ) begin
					next_state = fall_big;
					bigger_counter_in = 30;
					if(PositionX <= Size1) begin
						PositionX_in = PositionX + 10'd32;
					end
					else if(PositionX + Size1 >= 10'd639) begin
						PositionX_in = PositionX - 10'd32;
					end
					if(PositionY <= Size1) begin
						PositionY_in = PositionY + 10'd32;
					end
					else if(PositionY + Size1 >= 10'd479) begin
						PositionY_in = PositionY - 10'd32;
					end
				end
				
				// redBomb and Balls
				else if( Kid_position_Y + 10'd15 <= triggerY_redBomb) begin
					next_state = prepareBomb;
				end	
				
				// rush
				else begin
//				if( (Kid_position_Y + 10'd34 >= PositionY + half_height) || (Kid_position_Y + 10'd30 <= PositionY + half_height) ) begin
					rush_counter_in = rush_counter;
					if(Kid_position_X <= PositionX) begin
						next_state = rush;
					end
					else begin
						next_state = rush_back;
					end
				end
			end
			
			fall: begin
				MovementY_in = MovementY + 10'd2;
				PositionY_in = PositionY + MovementY;
				if(PositionY >= 10'd416) begin
					PositionY_in = 10'd416;
					if(Kid_position_X >= Boss_position_X) begin
						next_state = rush_back;
					end
					else begin
						next_state = rush;
					end
				end
			end
			
			fall_hurt: begin
				MovementY_in = MovementY + 10'd2;
				PositionY_in = PositionY + MovementY;
				if(PositionY >= 10'd400) begin
					PositionY_in = 10'd416;
					next_state = wudi;
				end
			end
			
			fall_big: begin
				MovementY_in = MovementY + 10'd2;
				PositionY_in = PositionY + MovementY;
				if(PositionY >= 10'd384) begin
					PositionY_in = 10'd384;
					next_state = bigger;
				end
				
			end
			
			jump: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				PositionY_in = PositionY + MovementY;
				MovementY_in = MovementY + 10'd2;
				if(PositionY <= triggerY_jump) begin
					PositionY_in = triggerY_jump;
					if(Kid_position_X >= Boss_position_X) begin
						next_state = rush_back;
					end
					else begin
						next_state = rush;
					end
				end
			end
			
			prepareBomb: begin
				shoot = 1'b1;
				next_state = sendBomb;
			end
			
			sendBomb: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				if(NoBomb) begin
					next_state = living;
				end
			end
			
			rush: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				if(rush_counter >= 10'd30) begin
					rush_counter_in = 10'd30;
				end
				else begin
					rush_counter_in = rush_counter + 10'd2;
				end
				MovementX_in = ~(rush_counter) + 10'd1;
				PositionX_in = PositionX + MovementX;
				if(PositionX + MovementX <= half_width) begin
					PositionX_in = half_width;
					next_state = living;
				end
			end
			
			rush_back: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				if(rush_counter >= 10'd30) begin
					rush_counter_in = 10'd30;
				end
				else begin
					rush_counter_in = rush_counter + 10'd2;
				end
				MovementX_in = rush_counter;
				PositionX_in = PositionX + MovementX;
				if(PositionX + MovementX >= 10'd607) begin
					PositionX_in = 10'd607;
					next_state = living;
				end	
			end
			
			bigger: begin
				// wudi or dead
				if(hitBullet) begin
					if(life > 0) begin
						life_in = life - 1;
						next_state = fall_hurt;
						MovementY_in = 10'd2;
						wudi_counter_in = 150;
					end
					else begin
						next_state = dead;
					end
				end
				if(DistX*DistX + DistY*DistY <= Size1*Size1) begin
					isBoss = 1'b1;
					offset = DistX + DistY*128 + 68479;
					Boss_address = offset[24:0];
				end
				if( KB_X*KB_X + KB_Y*KB_Y <= Size1*Size1 ) begin
					hitBoss_in = 1'b1;
				end
				if(bigger_counter == 0) begin
					PositionX_in = PositionX + 10'd32;
					PositionY_in = PositionY + 10'd32;
					next_state = living;
				end
				else begin
					bigger_counter_in = bigger_counter - 1;
				end
			end
			
				
			wudi: begin
				MovementX_in = 10'd2;
				if(Kid_position_X <= PositionX) begin
					MovementX_in = ~(10'd2) + 10'd1;
				end
				PositionX_in = PositionX + MovementX;
				if(PositionX <= half_width) begin
					PositionX_in = half_width;
					next_state = living;
				end
				wudi_counter_in = wudi_counter - 1;
				if(blink && isBoss == 1'b1)
				begin
					Boss_address = offset[24:0];
				end
				else
				begin
					Boss_address =25'd0;
				end
				if(life == 0) begin
					next_state = dead;
				end
				else if(wudi_counter == 0) begin
					if(Kid_position_X >= Boss_position_X) begin
						next_state = rush_back;
					end
					else begin
						next_state = rush;
					end
				end
			end
		
			dead: begin
				isBoss = 1'b0;
				Boss_address = 25'd0;
				hitBoss_in = 1'b0;
				Boss_dead = 1'b1;
			end	
		endcase
	end

endmodule


//
//
//module BossAddress(input logic [9:0] PositionX, PositionY,
//					input logic isBoss,
//					input logic direction,
//					output logic [24:0] Boss_address);
//	int DistX, DistY, image_off;
//	
//	
//	always_comb begin
//		DistX = PositionX;
//		DistY = PositionY;
//		image_off = DistX + DistY * 64 + 60352;
//		if(isBoss) begin
//			Boss_address = image_off[24:0];
//		end
//		else begin
//			Boss_address = 25'd0;
//		end
//	end
//					
//endmodule


module bullet_hit(input logic [9:0] bullet_X, bullet_Y,
				input logic [9:0] PositionX, PositionY,
				output logic hitBullet);
			
	parameter [9:0] range = 10'd64;		
			
	always_comb begin
		// left up of man
		if(bullet_X <= PositionX && bullet_X + 10'd64 >= PositionX && bullet_Y <= PositionY && bullet_Y + 10'd64 >= PositionY) begin
			hitBullet = 1'b1;
		end
		// right up of man
		if(bullet_X <= PositionX + 10'd64 && bullet_X >= PositionX && bullet_Y <= PositionY && bullet_Y + 10'd64 >= PositionY) begin
			hitBullet = 1'b1;
		end
		// left down of man
		if(bullet_X <= PositionX && bullet_X + 10'd64 >= PositionX && bullet_Y >= PositionY && bullet_Y <= PositionY + 10'd64 ) begin
			hitBullet = 1'b1;
		end
		// right down of man
		if(bullet_X >= PositionX && bullet_X <= PositionX + 10'd64 && bullet_Y >= PositionY && bullet_Y <= PositionY + 10'd64) begin
			hitBullet = 1'b1;
		end
		else begin
			hitBullet = 1'b0;
		end
	end	
endmodule


