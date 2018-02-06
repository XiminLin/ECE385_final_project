module stage_exit(
	input logic [9:0] DrawX_write,DrawY_write,
	input logic [3:0] stage,
	input logic clk_50_shift,
	output logic [24:0] Address
);
	
	int DistX, DistY, offset;
	assign DistX = DrawX_write;
	assign DistY = DrawY_write;
	assign offset = DistX + DistY*640 + 1819072;
	logic [24:0] final_address;
	address_selector5(
	.clk_50(clk_50_shift),
	.Professor_address(offset[24:0]),
	.Address(final_address)
	);

	always_comb
	begin
		Address = final_address;
		if(stage != 4'd5)
			Address = 25'd0;
	end	
endmodule



module stage_death(
	input logic [9:0] DrawX_write,DrawY_write,
	input logic [3:0] stage,
	input logic Reset_h,
	output logic [24:0] Address,
	input logic R,
	input logic collide,
	input logic frame_clk,
	input logic clk_50_shift
);
	logic isScore, isGameOver;
	logic [24:0] Score_address, GameOverAddress;
	logic [24:0] final_address;
	GameOver GO(
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.isGameOver,.GameOverAddress
	);
	
	print_score PS(
		.frame_clk,
		.resur(R),
		.clear_score(Reset_h),
		.collide,
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Score_address,
		.isScore
	);


	address_selector4(
		.clk_50(clk_50_shift),
		.isScore,.isGameOver,
		.Score_address,.GameOverAddress,
		.Address(final_address)
	);
	always_comb
	begin
		Address = final_address;
		if(stage != 4'd3)
			Address = 25'd0;
	end	


endmodule 


module stage_final(
	input logic [9:0] DrawX_write,DrawY_write,
	input logic [3:0] stage,
	input logic Reset_h,
	output logic [24:0] Address,
	output logic finish_game,
	input logic clk_50_shift,
	input logic frame_clk,
	input logic enter
);

	logic [3:0] letter,letter_in;
	logic isFinalScore,isLetter;
	logic finish_game_in;
	logic [24:0] FinalScoreAddress,LetterAddress;
//	assign isLetter = 1'b0;
//	assign LetterAddress = 25'd0;
	logic [24:0] final_address;
	ScrollScore scores(
		.letter,
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.isFinalScore,.FinalScoreAddress
	);
	address_selector3(
		.clk_50(clk_50_shift),
		.isFinalScore,.isLetter,
		.FinalScoreAddress,.LetterAddress,
		.Address(final_address)
	); 
	FinalGrade letters(
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.isFinalGrade(isLetter),
		.FinalGradeAddress(LetterAddress)
	
	);
	
	enum logic [4:0] {A,B,C,D,E,F,confirmed,confirmed_2} state,next_state;
	logic [3:0] counter,counter_in;
	
	always_ff @ (posedge frame_clk)
	begin
		counter <= counter_in;
		state <= next_state;
		letter <= letter_in;
		finish_game <= finish_game_in;
		if(Reset_h)
		begin
			counter <= 4'd0;
			state <= A;
			letter <= 4'd0;
			finish_game <= 1'b0;
		end
	end
	
	
	always_comb
	begin
		next_state = state;
		case(state)
			A: 
			begin
				if(enter == 1'b1)
					next_state = confirmed;
				else if(counter == 4'd3)
					next_state = B;
			end
			B:
			begin
				if(enter == 1'b1)
					next_state = confirmed;
				else if(counter == 4'd3)
					next_state = C;
			end
			C:
			begin
				if(enter == 1'b1)
					next_state = confirmed;
				else if(counter == 4'd3)
					next_state = D;
			end
			D:
			begin
				if(enter == 1'b1)
					next_state = confirmed;	
				else if(counter == 4'd3)
					next_state = E;
			end
			E:
			begin
				if(enter == 1'b1)
					next_state = confirmed;
				else if(counter == 4'd3)
					next_state = F;
			end
			F:
			begin
				if(enter == 1'b1)
					next_state = confirmed;
				else if(counter == 4'd3)
					next_state = A;
			end
			confirmed: 
			begin
				if(enter == 1'b0)
					next_state = confirmed_2;
			end
			confirmed_2: ;
		endcase
	
		letter_in = letter;
		counter_in = 4'd0;
		finish_game_in = finish_game;
		case(state)
			A,B,C,D,E,F:
			begin
				counter_in = counter + 4'd1;
				if(counter == 4'd3)
					counter_in = 4'd0;
			end
			confirmed: ;
			confirmed_2: ;
		endcase
		case(state)
			A: letter_in = 4'd0;
			B: letter_in = 4'd1;
			C: letter_in = 4'd2;
			D: letter_in = 4'd3;
			E: letter_in = 4'd4;
			F: letter_in = 4'd5;
			confirmed: ;
			confirmed_2:
			begin
				if(enter == 1'b1)
					finish_game_in = 1'b1;
			end
		
		endcase
		
		
	end
	
	
	
	
	always_comb
	begin
		Address = final_address;
		if(stage != 4'd4)
			Address = 25'd0;
	end	
endmodule 


module stage2(
	input logic [3:0] stage,
	output logic [24:0] Address,
	output logic saved,
	output logic death,
	output logic victory,
	input logic [9:0] DrawX_write,DrawY_write,
	input logic W, A ,D,
	input logic Reset_h,
	input logic test_mode,
	input logic shoot,
	input logic frame_clk,
	input logic clk_50_shift
);

	logic isBoss, isWall, isBullet, isKid, isRedBomb, isBall, isSave;
	logic hitBoss, hitSave, hitBall, hitBomb;
	logic [9:0] Boss_position_X, Boss_position_Y;
	logic [9:0] Reset_X,Reset_Y;
	logic [24:0] Kid_address, Boss_address, Wall_address, Bullet_address, Ball_address, Bomb_address, Save_address;
	logic [9:0] Bullet_X, Bullet_Y;
	logic collide;
	logic status_clk;
	logic Boss_dead;
	logic direction;
	logic hit_y, hit_top;
	logic Ground;
	logic [9:0] PositionX, PositionY;
	logic [9:0] MovementX, MovementY;
	logic [9:0] Kid_position_X_hit, Kid_position_Y_hit;
	logic [9:0] Kid_position_Y_top;
	logic [24:0] final_address;
	logic hitTotal;
	logic NoBomb;
	logic Boss_shoot;
	logic Boss_reset, Boss_reset_in;
	assign hitTotal = hitSave;
	assign Reset_X = 10'd0;
	assign Reset_Y = 10'd416;
	assign collide = (hitBoss | hitBall |hitBomb) & test_mode;
	assign victory = Boss_dead;
	int DistX,DistY,offset;
	logic [9:0] pic_X,pic_Y,pic_X_end,pic_Y_end;
	assign pic_X = 10'd0;
	assign pic_Y = 10'd100;
	assign pic_X_end = pic_X + 10'd639;
	assign pic_Y_end = pic_Y + 10'd190;
	assign DistX = DrawX_write - pic_X;
	assign DistY = DrawY_write - pic_Y;
	assign offset = DistX + DistY * 640 + 2127296;
	logic [24:0] Pic_address;
	logic isPic;
	assign Pic_address = offset[24:0];
	always_comb
	begin
		isPic = 1'b0;
		if(DrawX_write >= pic_X && DrawX_write <= pic_X_end && DrawY_write >= pic_Y && DrawY_write <= pic_Y_end)
			isPic = 1'b1;
	
	end
	always_comb
	begin
		death = 1'b0;
		if(stage == 4'd2)
			death = collide;
		
	end
	always_ff @ (posedge frame_clk)
	begin
		status_clk <= ~status_clk;
	end
	
	always_ff @ (posedge frame_clk)
	begin
		Boss_reset <= Boss_reset_in;
		if(Reset_h)
			Boss_reset <= 1'b1;
	end
	
	always_comb
	begin
		Boss_reset_in = Boss_reset;
		if(saved == 1'b1)
			Boss_reset_in = 1'b0;
	end
	
	Character char0(
		.frame_clk(status_clk),
		.Reset_h,
		.A,.D,
		.W,
		.Reset_X,.Reset_Y,
		.hit_y, .hit_top,
		.Kid_position_Y(Kid_position_Y_hit), .Kid_position_Y_top,
		.Ground,
		//.keycode,
		.direction,
		.collide,
		.PositionX,.PositionY,
		.MovementX,.MovementY,
		.DrawX(DrawX_write),
		.DrawY(DrawY_write),
		.Kid_address,	
		.isKid
	);

	Wall_set2 walls(
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.DrawX_write(DrawX_write),.DrawY_write(DrawY_write),
		.Kid_move_X(MovementX),.Kid_move_Y(MovementY),
		.hit_y, .hit_top,
		.Kid_position_Y_hit, .Kid_position_Y_top,
		.isWall,
		.Wall_address,
		.Ground
		);
		
	bullet_set bullets(
		.frame_clk(status_clk),
		.shoot(shoot),
		.Reset(Reset_h),
		.hit(hitTotal),
		.PositionX,.PositionY,
		.DrawX_write,.DrawY_write,
		.Bullet_X, .Bullet_Y,
		.isBullet,
		.direction,
		.Bullet_address
	);
	
	Boss(
		.frame_clk(status_clk),
		.Reset_h(Boss_reset),
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.bullet_X(Bullet_X),.bullet_Y(Bullet_Y),
		.NoBomb,
		.Boss_address,
		.shoot(Boss_shoot),
		.isBoss,
		.hitBoss,
		.Boss_position_X,.Boss_position_Y,
		.Boss_dead
	);
	
	
	save save0(
		.Position_X(10'd60),.Position_Y(10'd416),
		.Bullet_X, .Bullet_Y,
		.DrawX_write, .DrawY_write,
		.frame_clk,
		.Reset_h,
		.isSave,
		.Save_address,
		.hit(hitSave),
		.saved
	);
	
	RedBomb redbomb0(
		.frame_clk(status_clk),
		.shoot(Boss_shoot),
		.Reset_h(Boss_reset),
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.Boss_position_X(Boss_position_X),.Boss_position_Y(Boss_position_Y),
		.isRedBomb,
		.hitBomb,
		.NoBomb,
		.Bomb_address
	);
	
	allBall allball0(
		.frame_clk(status_clk),
		.Reset_h(Boss_reset),
		.moreBall(Boss_shoot),
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Boss_position_X,.Boss_position_Y,
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.isBall,.hitBall,.Ball_address
	);
	
	address_selector2 address_selection(
		.clk_50(clk_50_shift),
		.isKid, .isWall, .isBullet, .isRedBomb, .isBoss, .isBall, .isSave, .isPic,
		.Kid_address, .Boss_address, .Wall_address, .Bullet_address, .Ball_address, .Bomb_address, .Save_address, .Pic_address,
		.Address(final_address)
	);
	
	always_comb
	begin
		Address = final_address;
		if(stage != 4'd2)
			Address = 25'd0;
	end
endmodule



module stage0(
	input logic [3:0] stage,
	output logic [24:0] Address,
	output logic [3:0] selected_stage,
	output logic confirmed,
	input logic frame_clk,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic W,S,
	input logic Reset_h,
	input logic enter
);

	enum logic [2:0] {start,start_2, load,load_2,load_3, exit,exit_2} state, next_state;
	int offset1,offset2,offset3;
	int DrawX_int, DrawY_int;
	assign DrawX_int = DrawX_write;
	assign DrawY_int = DrawY_write;
	logic confirmed_in;
	assign offset1 = DrawX_int + DrawY_int*640 + 243648;
	assign offset2 = DrawX_int + DrawY_int*640 + 550848;
	assign offset3 = DrawX_int + DrawY_int*640 + 858048;
	always_ff @ (posedge frame_clk)
	begin
		state <= next_state;
		confirmed <= confirmed_in;
		if(Reset_h)
			state <= start;
	end
	
	always_comb
	begin
		next_state = state;
		case(state)
			start:
				if(S == 1'b1)
					next_state = start_2;
			start_2:
			begin
				if(S == 1'b0)
					next_state = load;	
			end
			load:
			begin
				if(S == 1'b1)
					next_state = load_2;
				else if(W == 1'b1)
					next_state = load_3;
			end
			load_2:
			begin
				if(S == 1'b0)
					next_state = exit;
			end
			load_3:
			begin
				if(W == 1'b0)
					next_state = start;
			end
			exit:
				if(W == 1'b1)
					next_state = exit_2;		
			exit_2:
				if(W == 1'b0)
					next_state = load;
		endcase
		selected_stage = 4'd0;
		confirmed_in = 1'b0;
		Address = 25'd0;
		case(state)
			start: 
			begin
				Address = offset1[24:0];
				selected_stage = 4'd1;
				if(enter == 1'b1)
					confirmed_in = 1'b1;
			end
			start_2:
			begin
				Address = offset1[24:0];
			end
			load:
			begin
				Address = offset2[24:0];
				selected_stage = 4'd2;
				if(enter == 1'b1)
					confirmed_in = 1'b1;
			end
			load_2:
				Address = offset2[24:0];
			load_3:
				Address = offset2[24:0];
			exit:
			begin
				Address = offset3[24:0];
				selected_stage = 4'd3;
				if(enter == 1'b1)
					confirmed_in = 1'b1;
			end
			exit_2:
				Address = offset3[24:0];
		endcase
		
		if(stage != 4'd0)
			Address = 25'd0;
	end
	
endmodule







module stage1(
	input logic [3:0] stage,
	output logic [24:0] Address,
	output logic saved,
	output logic reach_final,
	output logic death,
	input logic [9:0] DrawX_write, DrawY_write,
	input logic W, A ,D,
	input logic Reset_h,
	input logic test_mode,
	input logic shoot,
	input logic frame_clk,
	input logic clk_50_shift
	
);

	logic isApple, isWall, isKid, isSpur, isBullet, isCat, isSave, isTeleport;
	logic hitApple, hitCat, hitSpur, hitBullet, hitSave;
	logic [9:0] Reset_X,Reset_Y;
	logic [24:0] Apple_address, Cat_address, Kid_address, Wall_address, Bullet_address, Spur_address, Save_address, Teleport_address;
	logic [9:0] Bullet_X, Bullet_Y;
	logic status_clk; //we want to move the char at 30Hz
	logic collide;
	logic direction;
	logic hit_y, hit_top;
	logic Ground;
	logic [9:0] PositionX, PositionY;
	logic [9:0] MovementX, MovementY;
	logic [9:0] Kid_position_X_hit, Kid_position_Y_hit;
	logic [9:0] Kid_position_Y_top;
	logic [24:0] final_address;
	logic hitTotal;
	assign hitTotal = hitBullet | hitSave;
	assign collide = (hitSpur | hitApple |hitCat) & test_mode;
	assign Reset_X = 10'd0;
	assign Reset_Y = 10'd0;
	always_comb
	begin
		death = 1'b0;
		if(stage == 4'd1)
			death = collide;
		
	end
	always_ff @ (posedge frame_clk)
	begin
		status_clk <= ~status_clk;
	end

	Character char0(
		.frame_clk(status_clk),
		.Reset_h,
		.A,.D,
		.W,
		.Reset_X,.Reset_Y,
		.hit_y, .hit_top,
		.Kid_position_Y(Kid_position_Y_hit), .Kid_position_Y_top,
		.Ground,
		//.keycode,
		.direction,
		.collide,
		.PositionX,.PositionY,
		.MovementX,.MovementY,
		.DrawX(DrawX_write),
		.DrawY(DrawY_write),
		.Kid_address,	
		.isKid
	);
	
	Wall_set walls(
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.DrawX_write(DrawX_write),.DrawY_write(DrawY_write),
		.Kid_move_X(MovementX),.Kid_move_Y(MovementY),
		.hit_y, .hit_top,
		.Kid_position_Y_hit, .Kid_position_Y_top,
		.isWall,
		.Wall_address,
		.Ground
	);
	
	cat cat1(
		.frame_clk,
		.Reset_h,
		.Bullet_position_X(Bullet_X), .Bullet_position_Y(Bullet_Y),
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.Cat_address,
		.hitBullet, 
		.isCat,
		.hitCat
	);
	
	bullet_set bullets(
		.frame_clk(status_clk),
		.shoot(shoot),
		.Reset(Reset_h),
		.hit(hitTotal),
		.PositionX,.PositionY,
		.DrawX_write,.DrawY_write,
		.Bullet_X, .Bullet_Y,
		.isBullet,
		.direction,
		.Bullet_address
	);
	
	allSpur spurs(
		.Reset_h,
		.frame_clk(status_clk),
		.DrawX(DrawX_write),.DrawY(DrawY_write),
		.Kid_position_X(PositionX),.Kid_position_Y(PositionY),
		.Spur_address,
		.isSpur,
		.hitSpur
	);
	
	allApple apples(
	.frame_clk,
	.Reset_h,
	.DrawX(DrawX_write), .DrawY(DrawY_write),
	.Kid_position_X(PositionX), .Kid_position_Y(PositionY),
	.isApple,
	.Apple_address,
	.hitApple
	);
	
	address_selector address_selection(
		.clk_50(clk_50_shift),
		.isKid,.isWall, .isApple,.isSpur,.isBullet,.isCat, .isSave, .isTeleport,
		.Kid_address,.Wall_address, .Bullet_address, .Cat_address, .Save_address, .Teleport_address,
		.Apple_address, .Spur_address,
		.Address(final_address)
	);
	
	
	save save0(
		.Position_X(10'd36),.Position_Y(10'd106),
		.Bullet_X, .Bullet_Y,
		.DrawX_write, .DrawY_write,
		.frame_clk,
		.Reset_h,
		.isSave,
		.Save_address,
		.hit(hitSave),
		.saved
	);
	
	
	teleport teleport0(
		.Position_X(10'd608),.Position_Y(10'd315),
		.Reset_h,
		.Kid_Position_X(PositionX),.Kid_Position_Y(PositionY),
		.DrawX_write,.DrawY_write,
		.frame_clk,
		.reach_final,
		.isTeleport,
		.Teleport_address
	);
	
	always_comb
	begin
		Address = final_address;
		if(stage != 4'd1)
			Address = 25'd0;
	end
endmodule


