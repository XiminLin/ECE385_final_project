module ScrollScore(
				input logic [3:0] letter,
				input logic [9:0] DrawX, DrawY,
				output logic isFinalScore,
				output logic [24:0] FinalScoreAddress);
				
	parameter int width = 240;
	parameter int height = 240;
	
	parameter [9:0] init_X = 10'd200;
	parameter [9:0] init_Y = 10'd190;
	
	int DistX, DistY, letter_num;
	
	always_comb begin
		letter_num = letter;
		DistX = DrawX - init_X;
		DistY = DrawY - init_Y;
		FinalScoreAddress = 25'd0;
		isFinalScore = 1'b0;
		if(DrawX >= init_X && DrawY >= init_Y && DistX <= width && DistY <= height) begin
			isFinalScore = 1'b1;
			FinalScoreAddress = DistX + DistY*240 + letter_num*57600 + 1166272;
		end
	end
endmodule



module GameOver(input logic [9:0] DrawX, DrawY,
				output logic isGameOver,
				output logic [24:0] GameOverAddress);
				
	parameter int width = 640;
	parameter int height = 256;
	
	parameter [9:0] init_X = 10'd0;
	parameter [9:0] init_Y = 10'd60;
	
	int DistX, DistY;
	int offset;
	always_comb begin
		DistX = DrawX - init_X;
		DistY = DrawY - init_Y;
		GameOverAddress = 25'd0;
		offset = DistX + DistY*640 + 77760;
		isGameOver = 1'b0;
		if(DrawX > init_X && DrawY > init_Y && DistX < width && DistY < height) begin
			isGameOver = 1'b1;
			GameOverAddress = offset[24:0];
		end
	end			
endmodule


module FinalGrade(input logic [9:0] DrawX, DrawY,
				output logic isFinalGrade,
				output logic [24:0] FinalGradeAddress);
				
	parameter int width = 640;
	parameter int height = 480;
	
	parameter [9:0] init_X = 10'd0;
	parameter [9:0] init_Y = 10'd0;
	
	int DistX, DistY, offset;

	always_comb begin
		isFinalGrade = 1'b0;
		FinalGradeAddress = 25'd0;
		DistX = DrawX - init_X;
		DistY = DrawY - init_Y;
		offset = DistX + DistY*640 + 1511872;
		if(DrawX >= init_X && DrawY >= init_Y && DistX <= width && DistY <= height) begin
			isFinalGrade = 1'b1;
			FinalGradeAddress = offset[24:0]; 
		end
	end			
				
endmodule
