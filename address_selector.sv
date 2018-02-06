module address_selector5(
	input logic clk_50,
	input logic [24:0] Professor_address,
	output logic [24:0] Address
);
	always_ff @ (posedge clk_50)
	begin
		Address <= Professor_address;
	end
endmodule


module address_selector4(
	input logic clk_50,
	input logic isScore, isGameOver,
	input logic [24:0] Score_address, GameOverAddress,
	output logic [24:0] Address
);

	always_ff @ (posedge clk_50)
	begin
		Address <= 25'd0;
		if(isScore)
			Address <= Score_address;
		else if(isGameOver)
			Address <= GameOverAddress;
	
	end

	

endmodule
module address_selector3(
	input logic clk_50,
	input logic isFinalScore,isLetter,
	input logic [24:0] FinalScoreAddress, LetterAddress,
	output logic [24:0] Address
);

	always_ff @ (posedge clk_50)
	begin
		Address <= 25'd0;
		if(isFinalScore)
			Address <= FinalScoreAddress;
		else if(isLetter)
			Address <= LetterAddress;
		
	end


endmodule 


module address_selector2(
	input logic clk_50,
	input logic isKid, isWall, isBullet, isRedBomb, isBoss, isBall, isSave, isPic,
	input logic [24:0] Kid_address, Boss_address, Wall_address, Bullet_address, Ball_address, Bomb_address, Save_address,Pic_address,
	output logic [24:0] Address
);
	always_ff @ (posedge clk_50)
	begin
		Address <= 25'd0;
		if(isBullet)
			Address <= Bullet_address;
		else if(isSave)
			Address <= Save_address;
		else if(isBoss)
			Address <= Boss_address;
		else if(isRedBomb)
			Address <= Bomb_address;
		else if(isBall)
			Address <= Ball_address;
		else if(isWall)
			Address <= Wall_address;
		else if(isKid)
			Address <= Kid_address;
		else if(isPic)
			Address <= Pic_address;
	end



endmodule 

//this module is a MUX to select the corresponding address in the SDRAM
//its output address will be sent to print and get the pixel from SDRAM
//because our double frame buffer cannot print multiple layers, we have
//to choose the right address at first
module address_selector(
	input logic clk_50,
	input logic isKid,
					isWall,
					isApple,
					isSpur,
					isBullet,
					isCat,
					isSave,
					isTeleport,
	input logic [24:0] Kid_address,
							 Wall_address,
							 Apple_address,
							 Spur_address,
							 Boss_address,
							 Bullet_address,
							 Cat_address,
							 Save_address,
							 Teleport_address,
	output logic [24:0] Address

);


	always_ff @ (posedge clk_50)
	begin
//		Address = Kid_address | Wall_address | Apple_address | Spur_address | Boss_address; //default case
		
		Address <= 25'd0;
		if(isTeleport)
			Address <= Teleport_address;
		else if(isSave)
			Address <= Save_address;
		else if(isCat)
			Address <= Cat_address;
		else if(isBullet)
			Address <= Bullet_address; 
		else if(isApple)
			Address <= Apple_address;
		else if(isWall) 
			Address <= Wall_address;
		else if(isSpur)
			Address <= Spur_address;
		else if(isKid)
			Address <= Kid_address;

	end
	
endmodule

