module print_score(input logic frame_clk,
					input logic resur,
					input logic clear_score,
					input logic collide,
					input logic [9:0] DrawX, DrawY,
					output logic [24:0] Score_address,
					output logic isScore
					);
					
	parameter [9:0] fontX = 10'd0;
	parameter [9:0] fontY = 10'd0;
	
	logic char0, char1, char2, char3, char4, char5, char6, char7, char8;
	logic [24:0] char0Address, char1Address, char2Address, char3Address, char4Address, char5Address, char6Address, char7Address, char8Address;
	logic collide_stop, collide_stop_in;
	
	int char_off0, char_off1, char_off2;
	
	int zero_score, zero_score_in;
	int ten_score, ten_score_in;
	logic enable0, enable1, enable2;
	
	parameter [0:16][7:0] charOff_list = {
		8'h30,		// 0
		8'h31,
		8'h32,
		8'h33,
		8'h34,
		8'h35,
		8'h36,
		8'h37,
		8'h38,	
		8'h39,		// 9
		8'h4c,		// L
		8'h69,		// i
		8'h66,		// f
		8'h65,		// e
		8'h3a,		// :
		8'h58,		// X
		8'h0		// nothing
	};
		
	always_ff @ (posedge frame_clk)	begin
		if(clear_score) begin
			zero_score <= 0;
			ten_score <= 0;
			collide_stop <= 1'b0;
		end
		else begin
			zero_score <= zero_score_in;
			ten_score <= ten_score_in;
			collide_stop <= collide_stop_in;
		end
	end
	
	always_comb begin
		zero_score_in = zero_score;
		ten_score_in = ten_score;
		collide_stop_in = collide_stop;
		if(resur) begin
			collide_stop_in = 1'b0;
		end
		if(collide && ~collide_stop) begin
			collide_stop_in = 1'b1;
			if(zero_score >= 9) begin
				zero_score_in = 0;
				if(ten_score < 9) begin
					ten_score_in = ten_score + 1;
				end
				else begin
					ten_score_in = 0;
				end	
			end
			else begin
				zero_score_in = zero_score + 1;
			end
		end 
	end
	
	always_comb begin
		enable1 = 1'b1;
		enable2 = 1'b1;
		char_off1 = 16;
		char_off2 = 16;
		if(ten_score == 0) begin
			enable2 = 1'b0;
			char_off1 = zero_score;
		end
		else begin
			char_off1 = ten_score;
			char_off2 = zero_score;
		end
	end

	Pic  kid(.*, 	.enable(1'b1), 	  .charX(10'd147), .charY(10'd202), 							   		  .isChar(char8), .charAddress(char8Address) );
	Char colon(.*, 	.enable(1'b1), 	  .charX(10'd90), .charY(10'd104), .charOff(charOff_list[14]), 		  .isChar(char4), .charAddress(char4Address) );
	Char score1(.*, .enable(enable1), .charX(10'd100), .charY(10'd104), .charOff(charOff_list[char_off1]), .isChar(char6), .charAddress(char6Address) );
	Char score2(.*, .enable(enable2), .charX(10'd110), .charY(10'd104), .charOff(charOff_list[char_off2]), .isChar(char7), .charAddress(char7Address) );
	
	assign isScore = char4 | char6 | char7 | char8;
	assign Score_address = char4Address | char6Address | char7Address | char8Address;
					
endmodule


module Pic(
			input logic resur,
			input logic enable,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] charX, charY,
			output logic isChar,
			output logic [24:0] charAddress
			);
			
	logic [9:0] DrawX_half;
	assign DrawX_half = {signed'(DrawX[9]), DrawX[9:1]};
	logic [9:0] DrawY_half;
	assign DrawY_half = {signed'(DrawY[9]), DrawY[9:1]};
			
	parameter [9:0] width = 10'd32;
	parameter [9:0] height = 10'd32;
	
	logic [10:0] rom_address;
	logic [7:0] dataMap;
	
	int DistX, DistY;
	
	logic isChar_in;
	logic [24:0] charAddress_in;
	
	logic [24:0] offset, image_off;
	
	always_comb begin
		DistX = DrawX_half - charX;
		DistY = DrawY_half - charY;
		offset = {15'd0,DistX[9:0]} + {10'd0,DistY[9:0],5'd0} + 25'd1024;
//		image_off = {18'd0,11'd0} + {22'd0,10'd0};
		charAddress_in = 25'd0;
		isChar_in = 1'b0;
		if(DrawX_half >= charX && DrawY_half >= charY && DistX < width && DistY < height) begin
			isChar_in = 1'b1;
			charAddress_in = offset;
		end
	end
	
	assign isChar = isChar_in;
	assign charAddress = charAddress_in;
	
//	always_ff @ (negedge frame_clk) begin
//		if(resur) begin
//			isChar <= 1'b0 & enable;
//			charAddress <= 25'd0;
//		end
//		else begin
//			isChar <= isChar_in & enable;
//			charAddress <= enable ? charAddress_in : 25'd0;
//		end
//	end		
			
endmodule



module Char(//input logic Clock_50,
			input logic resur,
			input logic enable,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] charX, charY,
			input logic [7:0] charOff,
			output logic isChar,
			output logic [24:0] charAddress
			);
			
	logic [9:0] DrawX_quarter;
	assign DrawX_quarter = {2'(signed'(DrawX[9])), DrawX[9:2]};
	logic [9:0] DrawY_quarter;
	assign DrawY_quarter = {2'(signed'(DrawY[9])), DrawY[9:2]};
			
//	parameter [9:0] width = 10'd8;
//	parameter [9:0] height = 10'd16;
//	
	int width = 8;
	int height = 16;
	
	logic [10:0] rom_address;
	logic [7:0] dataMap;
	
	int DistX, DistY;
	int h_offset;
	assign h_offset = 8 - DistX;
	
//	logic isChar_in;
//	logic [24:0] charAddress_in;
	
	font_rom fr0(.addr(rom_address), .data(dataMap) );
	
//	always_ff @ (negedge Clock_50) begin
////		if(resur) begin
////			isChar <= 1'b0 & enable;
////			charAddress <= 25'd0;
////		end
////		else begin
//		isChar <= isChar_in & enable;
//		charAddress <= enable ? charAddress_in : 25'd0;
////		end
//	end
	
	always_comb begin
		DistX = DrawX_quarter - charX;
		DistY = DrawY_quarter - charY;
		isChar = 1'b0;
		rom_address = 11'd0;
		if( (DrawX_quarter > charX) && (DistX <= width) && (DrawY_quarter > charY) && (DistY <= height) ) begin
			rom_address = {3'd0,DistY[7:0]} + {charOff[6:0],4'd0};
			isChar = dataMap[h_offset];
		end
	end
	
	always_comb begin
		if(isChar) begin
			charAddress = 25'd1;
		end
		else begin
			charAddress = 25'd0;
		end
	end

endmodule

