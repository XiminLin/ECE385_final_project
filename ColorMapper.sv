module ColorMapper(input logic Clk,
					//input logic VGA_CLK,
					input logic [9:0] DrawX,DrawY,
					input logic [7:0] palette_idx,
					input logic isKid, sram_read_ready,
					output logic [7:0]  VGA_R,
										VGA_B,
										VGA_G
					);
	
	// palette store in RAM
	always_ff @ (posedge Clk) begin
		if(DrawY == 10'd0)
		begin
			VGA_R <= 8'd0;
			VGA_G <= 8'd0;
			VGA_B <= 8'd0;
		end
		else if(sram_read_ready)
		
		case(palette_idx)

			8'd0: begin VGA_R <= 8'd64; VGA_G <= 8'd128; VGA_B <= 8'd0; end
			8'd1: begin VGA_R <= 8'd8; VGA_G <= 8'd0; VGA_B <= 8'd0; end
			8'd2: begin VGA_R <= 8'd100; VGA_G <= 8'd0; VGA_B <= 8'd0; end
			8'd3: begin VGA_R <= 8'd243; VGA_G <= 8'd0; VGA_B <= 8'd0; end
			8'd4: begin VGA_R <= 8'd243; VGA_G <= 8'd91; VGA_B <= 8'd91; end
			8'd5: begin VGA_R <= 8'd20; VGA_G <= 8'd20; VGA_B <= 8'd20; end
			8'd6: begin VGA_R <= 8'd38; VGA_G <= 8'd38; VGA_B <= 8'd38; end
			8'd7: begin VGA_R <= 8'd199; VGA_G <= 8'd199; VGA_B <= 8'd199; end
			8'd8: begin VGA_R <= 8'd227; VGA_G <= 8'd227; VGA_B <= 8'd227; end
			8'd9: begin VGA_R <= 8'd237; VGA_G <= 8'd237; VGA_B <= 8'd237; end
			8'd10: begin VGA_R <= 8'd172; VGA_G <= 8'd172; VGA_B <= 8'd172; end
			8'd11: begin VGA_R <= 8'd159; VGA_G <= 8'd159; VGA_B <= 8'd159; end
			8'd12: begin VGA_R <= 8'd139; VGA_G <= 8'd139; VGA_B <= 8'd139; end
			8'd13: begin VGA_R <= 8'd129; VGA_G <= 8'd129; VGA_B <= 8'd129; end
			8'd14: begin VGA_R <= 8'd107; VGA_G <= 8'd107; VGA_B <= 8'd107; end
			8'd15: begin VGA_R <= 8'd96; VGA_G <= 8'd96; VGA_B <= 8'd96; end
			8'd16: begin VGA_R <= 8'd84; VGA_G <= 8'd84; VGA_B <= 8'd84; end
			8'd17: begin VGA_R <= 8'd69; VGA_G <= 8'd69; VGA_B <= 8'd69; end
			8'd18: begin VGA_R <= 8'd55; VGA_G <= 8'd55; VGA_B <= 8'd55; end
			8'd19: begin VGA_R <= 8'd252; VGA_G <= 8'd211; VGA_B <= 8'd212; end
			8'd20: begin VGA_R <= 8'd250; VGA_G <= 8'd193; VGA_B <= 8'd195; end
			8'd21: begin VGA_R <= 8'd252; VGA_G <= 8'd221; VGA_B <= 8'd222; end
			8'd22: begin VGA_R <= 8'd248; VGA_G <= 8'd164; VGA_B <= 8'd167; end
			8'd23: begin VGA_R <= 8'd243; VGA_G <= 8'd101; VGA_B <= 8'd106; end
			8'd24: begin VGA_R <= 8'd240; VGA_G <= 8'd71; VGA_B <= 8'd77; end
			8'd25: begin VGA_R <= 8'd246; VGA_G <= 8'd146; VGA_B <= 8'd150; end
			8'd26: begin VGA_R <= 8'd244; VGA_G <= 8'd124; VGA_B <= 8'd128; end
			8'd27: begin VGA_R <= 8'd238; VGA_G <= 8'd39; VGA_B <= 8'd46; end
			8'd28: begin VGA_R <= 8'd237; VGA_G <= 8'd26; VGA_B <= 8'd34; end
			8'd29: begin VGA_R <= 8'd255; VGA_G <= 8'd255; VGA_B <= 8'd255; end
			8'd30: begin VGA_R <= 8'd254; VGA_G <= 8'd248; VGA_B <= 8'd233; end
			8'd31: begin VGA_R <= 8'd254; VGA_G <= 8'd242; VGA_B <= 8'd215; end
			8'd32: begin VGA_R <= 8'd252; VGA_G <= 8'd235; VGA_B <= 8'd193; end
			8'd33: begin VGA_R <= 8'd252; VGA_G <= 8'd229; VGA_B <= 8'd175; end
			8'd34: begin VGA_R <= 8'd251; VGA_G <= 8'd222; VGA_B <= 8'd151; end
			8'd35: begin VGA_R <= 8'd250; VGA_G <= 8'd214; VGA_B <= 8'd129; end
			8'd36: begin VGA_R <= 8'd249; VGA_G <= 8'd208; VGA_B <= 8'd109; end
			8'd37: begin VGA_R <= 8'd248; VGA_G <= 8'd201; VGA_B <= 8'd87; end
			8'd38: begin VGA_R <= 8'd223; VGA_G <= 8'd181; VGA_B <= 8'd67; end
			8'd39: begin VGA_R <= 8'd174; VGA_G <= 8'd135; VGA_B <= 8'd47; end
			8'd40: begin VGA_R <= 8'd130; VGA_G <= 8'd102; VGA_B <= 8'd36; end
			8'd41: begin VGA_R <= 8'd90; VGA_G <= 8'd71; VGA_B <= 8'd26; end
			8'd42: begin VGA_R <= 8'd61; VGA_G <= 8'd49; VGA_B <= 8'd18; end
			8'd43: begin VGA_R <= 8'd41; VGA_G <= 8'd34; VGA_B <= 8'd12; end
			8'd44: begin VGA_R <= 8'd30; VGA_G <= 8'd26; VGA_B <= 8'd10; end
			8'd45: begin VGA_R <= 8'd106; VGA_G <= 8'd88; VGA_B <= 8'd35; end
			8'd46: begin VGA_R <= 8'd163; VGA_G <= 8'd138; VGA_B <= 8'd58; end
			8'd47: begin VGA_R <= 8'd195; VGA_G <= 8'd166; VGA_B <= 8'd70; end
			8'd48: begin VGA_R <= 8'd185; VGA_G <= 8'd149; VGA_B <= 8'd56; end
			8'd49: begin VGA_R <= 8'd121; VGA_G <= 8'd121; VGA_B <= 8'd120; end
			8'd50: begin VGA_R <= 8'd46; VGA_G <= 8'd46; VGA_B <= 8'd45; end
			8'd51: begin VGA_R <= 8'd181; VGA_G <= 8'd160; VGA_B <= 8'd72; end
			8'd52: begin VGA_R <= 8'd211; VGA_G <= 8'd210; VGA_B <= 8'd210; end
			8'd53: begin VGA_R <= 8'd187; VGA_G <= 8'd187; VGA_B <= 8'd187; end
			8'd54: begin VGA_R <= 8'd210; VGA_G <= 8'd192; VGA_B <= 8'd93; end
			8'd55: begin VGA_R <= 8'd235; VGA_G <= 8'd193; VGA_B <= 8'd115; end
			8'd56: begin VGA_R <= 8'd159; VGA_G <= 8'd146; VGA_B <= 8'd71; end
			8'd57: begin VGA_R <= 8'd232; VGA_G <= 8'd219; VGA_B <= 8'd192; end
			8'd58: begin VGA_R <= 8'd105; VGA_G <= 8'd100; VGA_B <= 8'd85; end
			8'd59: begin VGA_R <= 8'd217; VGA_G <= 8'd206; VGA_B <= 8'd102; end
			8'd60: begin VGA_R <= 8'd169; VGA_G <= 8'd136; VGA_B <= 8'd73; end
			8'd61: begin VGA_R <= 8'd210; VGA_G <= 8'd197; VGA_B <= 8'd169; end
			8'd62: begin VGA_R <= 8'd163; VGA_G <= 8'd144; VGA_B <= 8'd111; end
			8'd63: begin VGA_R <= 8'd132; VGA_G <= 8'd125; VGA_B <= 8'd108; end
			8'd64: begin VGA_R <= 8'd195; VGA_G <= 8'd150; VGA_B <= 8'd75; end
			8'd65: begin VGA_R <= 8'd217; VGA_G <= 8'd169; VGA_B <= 8'd88; end
			8'd66: begin VGA_R <= 8'd236; VGA_G <= 8'd164; VGA_B <= 8'd40; end
			8'd67: begin VGA_R <= 8'd229; VGA_G <= 8'd116; VGA_B <= 8'd36; end
			8'd68: begin VGA_R <= 8'd211; VGA_G <= 8'd67; VGA_B <= 8'd34; end
			8'd69: begin VGA_R <= 8'd224; VGA_G <= 8'd102; VGA_B <= 8'd36; end
			8'd70: begin VGA_R <= 8'd195; VGA_G <= 8'd17; VGA_B <= 8'd33; end
			8'd71: begin VGA_R <= 8'd237; VGA_G <= 8'd136; VGA_B <= 8'd35; end
			8'd72: begin VGA_R <= 8'd255; VGA_G <= 8'd18; VGA_B <= 8'd17; end
			8'd73: begin VGA_R <= 8'd229; VGA_G <= 8'd16; VGA_B <= 8'd15; end
			8'd74: begin VGA_R <= 8'd38; VGA_G <= 8'd3; VGA_B <= 8'd3; end
			8'd75: begin VGA_R <= 8'd71; VGA_G <= 8'd60; VGA_B <= 8'd44; end
			8'd76: begin VGA_R <= 8'd54; VGA_G <= 8'd45; VGA_B <= 8'd33; end
			8'd77: begin VGA_R <= 8'd181; VGA_G <= 8'd152; VGA_B <= 8'd111; end
			8'd78: begin VGA_R <= 8'd100; VGA_G <= 8'd83; VGA_B <= 8'd61; end
			8'd79: begin VGA_R <= 8'd210; VGA_G <= 8'd15; VGA_B <= 8'd14; end
			8'd80: begin VGA_R <= 8'd193; VGA_G <= 8'd17; VGA_B <= 8'd15; end
			8'd81: begin VGA_R <= 8'd69; VGA_G <= 8'd34; VGA_B <= 8'd25; end
			8'd82: begin VGA_R <= 8'd197; VGA_G <= 8'd164; VGA_B <= 8'd120; end
			8'd83: begin VGA_R <= 8'd128; VGA_G <= 8'd106; VGA_B <= 8'd78; end
			8'd84: begin VGA_R <= 8'd147; VGA_G <= 8'd11; VGA_B <= 8'd10; end
			8'd85: begin VGA_R <= 8'd236; VGA_G <= 8'd196; VGA_B <= 8'd144; end
			8'd86: begin VGA_R <= 8'd255; VGA_G <= 8'd168; VGA_B <= 8'd247; end
			8'd87: begin VGA_R <= 8'd217; VGA_G <= 8'd180; VGA_B <= 8'd133; end
			8'd88: begin VGA_R <= 8'd255; VGA_G <= 8'd74; VGA_B <= 8'd15; end
			8'd89: begin VGA_R <= 8'd255; VGA_G <= 8'd144; VGA_B <= 8'd12; end
			8'd90: begin VGA_R <= 8'd249; VGA_G <= 8'd135; VGA_B <= 8'd231; end
			8'd91: begin VGA_R <= 8'd239; VGA_G <= 8'd89; VGA_B <= 8'd192; end
			8'd92: begin VGA_R <= 8'd243; VGA_G <= 8'd108; VGA_B <= 8'd208; end
			8'd93: begin VGA_R <= 8'd255; VGA_G <= 8'd171; VGA_B <= 8'd11; end
			8'd94: begin VGA_R <= 8'd236; VGA_G <= 8'd73; VGA_B <= 8'd179; end
			8'd95: begin VGA_R <= 8'd137; VGA_G <= 8'd68; VGA_B <= 8'd7; end
			8'd96: begin VGA_R <= 8'd137; VGA_G <= 8'd93; VGA_B <= 8'd6; end
			8'd97: begin VGA_R <= 8'd237; VGA_G <= 8'd154; VGA_B <= 8'd237; end
			8'd98: begin VGA_R <= 8'd77; VGA_G <= 8'd50; VGA_B <= 8'd77; end
			8'd99: begin VGA_R <= 8'd47; VGA_G <= 8'd31; VGA_B <= 8'd47; end
			8'd100: begin VGA_R <= 8'd178; VGA_G <= 8'd116; VGA_B <= 8'd178; end
			8'd101: begin VGA_R <= 8'd35; VGA_G <= 8'd23; VGA_B <= 8'd35; end
			8'd102: begin VGA_R <= 8'd159; VGA_G <= 8'd104; VGA_B <= 8'd159; end
			8'd103: begin VGA_R <= 8'd255; VGA_G <= 8'd194; VGA_B <= 8'd10; end
			8'd104: begin VGA_R <= 8'd255; VGA_G <= 8'd227; VGA_B <= 8'd9; end
			8'd105: begin VGA_R <= 8'd91; VGA_G <= 8'd59; VGA_B <= 8'd91; end
			8'd106: begin VGA_R <= 8'd96; VGA_G <= 8'd77; VGA_B <= 8'd96; end
			8'd107: begin VGA_R <= 8'd118; VGA_G <= 8'd71; VGA_B <= 8'd114; end
			8'd108: begin VGA_R <= 8'd255; VGA_G <= 8'd255; VGA_B <= 8'd8; end
			8'd109: begin VGA_R <= 8'd194; VGA_G <= 8'd125; VGA_B <= 8'd194; end
			8'd110: begin VGA_R <= 8'd151; VGA_G <= 8'd149; VGA_B <= 8'd151; end
			8'd111: begin VGA_R <= 8'd137; VGA_G <= 8'd116; VGA_B <= 8'd5; end
			8'd112: begin VGA_R <= 8'd131; VGA_G <= 8'd85; VGA_B <= 8'd131; end
			8'd113: begin VGA_R <= 8'd137; VGA_G <= 8'd137; VGA_B <= 8'd4; end
			8'd114: begin VGA_R <= 8'd145; VGA_G <= 8'd98; VGA_B <= 8'd145; end
			8'd115: begin VGA_R <= 8'd158; VGA_G <= 8'd121; VGA_B <= 8'd121; end
			8'd116: begin VGA_R <= 8'd158; VGA_G <= 8'd133; VGA_B <= 8'd96; end
			8'd117: begin VGA_R <= 8'd191; VGA_G <= 8'd255; VGA_B <= 8'd9; end
			8'd118: begin VGA_R <= 8'd110; VGA_G <= 8'd255; VGA_B <= 8'd11; end
			8'd119: begin VGA_R <= 8'd224; VGA_G <= 8'd255; VGA_B <= 8'd9; end
			8'd120: begin VGA_R <= 8'd173; VGA_G <= 8'd255; VGA_B <= 8'd10; end
			8'd121: begin VGA_R <= 8'd70; VGA_G <= 8'd255; VGA_B <= 8'd12; end
			8'd122: begin VGA_R <= 8'd137; VGA_G <= 8'd255; VGA_B <= 8'd11; end
			8'd123: begin VGA_R <= 8'd108; VGA_G <= 8'd152; VGA_B <= 8'd6; end
			8'd124: begin VGA_R <= 8'd90; VGA_G <= 8'd88; VGA_B <= 8'd3; end
			8'd125: begin VGA_R <= 8'd49; VGA_G <= 8'd49; VGA_B <= 8'd2; end
			8'd126: begin VGA_R <= 8'd26; VGA_G <= 8'd95; VGA_B <= 8'd4; end
			8'd127: begin VGA_R <= 8'd69; VGA_G <= 8'd237; VGA_B <= 8'd11; end
			8'd128: begin VGA_R <= 8'd41; VGA_G <= 8'd140; VGA_B <= 8'd7; end
			8'd129: begin VGA_R <= 8'd36; VGA_G <= 8'd123; VGA_B <= 8'd6; end
			8'd130: begin VGA_R <= 8'd14; VGA_G <= 8'd47; VGA_B <= 8'd2; end
			8'd131: begin VGA_R <= 8'd64; VGA_G <= 8'd220; VGA_B <= 8'd10; end
			8'd132: begin VGA_R <= 8'd9; VGA_G <= 8'd31; VGA_B <= 8'd1; end
			8'd133: begin VGA_R <= 8'd65; VGA_G <= 8'd242; VGA_B <= 8'd50; end
			8'd134: begin VGA_R <= 8'd53; VGA_G <= 8'd225; VGA_B <= 8'd97; end
			8'd135: begin VGA_R <= 8'd70; VGA_G <= 8'd249; VGA_B <= 8'd30; end
			8'd136: begin VGA_R <= 8'd49; VGA_G <= 8'd165; VGA_B <= 8'd8; end
			8'd137: begin VGA_R <= 8'd50; VGA_G <= 8'd150; VGA_B <= 8'd15; end
			8'd138: begin VGA_R <= 8'd60; VGA_G <= 8'd73; VGA_B <= 8'd55; end
			8'd139: begin VGA_R <= 8'd48; VGA_G <= 8'd219; VGA_B <= 8'd120; end
			8'd140: begin VGA_R <= 8'd15; VGA_G <= 8'd174; VGA_B <= 8'd253; end
			8'd141: begin VGA_R <= 8'd19; VGA_G <= 8'd179; VGA_B <= 8'd237; end
			8'd142: begin VGA_R <= 8'd62; VGA_G <= 8'd238; VGA_B <= 8'd63; end
			8'd143: begin VGA_R <= 8'd32; VGA_G <= 8'd197; VGA_B <= 8'd185; end
			8'd144: begin VGA_R <= 8'd39; VGA_G <= 8'd207; VGA_B <= 8'd155; end
			8'd145: begin VGA_R <= 8'd29; VGA_G <= 8'd135; VGA_B <= 8'd79; end
			8'd146: begin VGA_R <= 8'd205; VGA_G <= 8'd167; VGA_B <= 8'd169; end
			8'd147: begin VGA_R <= 8'd173; VGA_G <= 8'd142; VGA_B <= 8'd144; end
			8'd148: begin VGA_R <= 8'd122; VGA_G <= 8'd97; VGA_B <= 8'd99; end
			8'd149: begin VGA_R <= 8'd9; VGA_G <= 8'd109; VGA_B <= 8'd158; end
			8'd150: begin VGA_R <= 8'd230; VGA_G <= 8'd166; VGA_B <= 8'd168; end
			8'd151: begin VGA_R <= 8'd147; VGA_G <= 8'd96; VGA_B <= 8'd98; end
			8'd152: begin VGA_R <= 8'd11; VGA_G <= 8'd130; VGA_B <= 8'd189; end
			8'd153: begin VGA_R <= 8'd5; VGA_G <= 8'd58; VGA_B <= 8'd84; end
			8'd154: begin VGA_R <= 8'd30; VGA_G <= 8'd70; VGA_B <= 8'd90; end
			8'd155: begin VGA_R <= 8'd3; VGA_G <= 8'd35; VGA_B <= 8'd51; end
			8'd156: begin VGA_R <= 8'd8; VGA_G <= 8'd94; VGA_B <= 8'd135; end
			8'd157: begin VGA_R <= 8'd25; VGA_G <= 8'd164; VGA_B <= 8'd255; end
			8'd158: begin VGA_R <= 8'd36; VGA_G <= 8'd152; VGA_B <= 8'd255; end
			8'd159: begin VGA_R <= 8'd12; VGA_G <= 8'd143; VGA_B <= 8'd209; end
			8'd160: begin VGA_R <= 8'd4; VGA_G <= 8'd44; VGA_B <= 8'd63; end
			8'd161: begin VGA_R <= 8'd11; VGA_G <= 8'd122; VGA_B <= 8'd178; end
			8'd162: begin VGA_R <= 8'd218; VGA_G <= 8'd147; VGA_B <= 8'd149; end
			8'd163: begin VGA_R <= 8'd202; VGA_G <= 8'd131; VGA_B <= 8'd133; end
			8'd164: begin VGA_R <= 8'd128; VGA_G <= 8'd84; VGA_B <= 8'd86; end
			8'd165: begin VGA_R <= 8'd58; VGA_G <= 8'd130; VGA_B <= 8'd255; end
			8'd166: begin VGA_R <= 8'd112; VGA_G <= 8'd74; VGA_B <= 8'd255; end
			8'd167: begin VGA_R <= 8'd14; VGA_G <= 8'd164; VGA_B <= 8'd238; end
			8'd168: begin VGA_R <= 8'd56; VGA_G <= 8'd46; VGA_B <= 8'd137; end
			8'd169: begin VGA_R <= 8'd141; VGA_G <= 8'd118; VGA_B <= 8'd87; end
			8'd170: begin VGA_R <= 8'd58; VGA_G <= 8'd34; VGA_B <= 8'd124; end
			8'd171: begin VGA_R <= 8'd139; VGA_G <= 8'd80; VGA_B <= 8'd255; end
			8'd172: begin VGA_R <= 8'd90; VGA_G <= 8'd39; VGA_B <= 8'd18; end
			8'd173: begin VGA_R <= 8'd255; VGA_G <= 8'd199; VGA_B <= 8'd143; end
			8'd174: begin VGA_R <= 8'd171; VGA_G <= 8'd0; VGA_B <= 8'd0; end
			8'd175: begin VGA_R <= 8'd17; VGA_G <= 8'd26; VGA_B <= 8'd143; end
			8'd176: begin VGA_R <= 8'd63; VGA_G <= 8'd6; VGA_B <= 8'd6; end
			8'd177: begin VGA_R <= 8'd21; VGA_G <= 8'd66; VGA_B <= 8'd105; end
			8'd178: begin VGA_R <= 8'd77; VGA_G <= 8'd224; VGA_B <= 8'd19; end
			8'd179: begin VGA_R <= 8'd52; VGA_G <= 8'd188; VGA_B <= 8'd0; end
			8'd180: begin VGA_R <= 8'd106; VGA_G <= 8'd80; VGA_B <= 8'd16; end
			8'd181: begin VGA_R <= 8'd214; VGA_G <= 8'd202; VGA_B <= 8'd190; end
			8'd182: begin VGA_R <= 8'd195; VGA_G <= 8'd215; VGA_B <= 8'd247; end
			8'd183: begin VGA_R <= 8'd0; VGA_G <= 8'd192; VGA_B <= 8'd192; end
			8'd184: begin VGA_R <= 8'd0; VGA_G <= 8'd162; VGA_B <= 8'd232; end
			8'd185: begin VGA_R <= 8'd194; VGA_G <= 8'd98; VGA_B <= 8'd187; end
			8'd186: begin VGA_R <= 8'd153; VGA_G <= 8'd77; VGA_B <= 8'd148; end
			8'd187: begin VGA_R <= 8'd58; VGA_G <= 8'd28; VGA_B <= 8'd54; end
			8'd188: begin VGA_R <= 8'd209; VGA_G <= 8'd106; VGA_B <= 8'd203; end
			8'd189: begin VGA_R <= 8'd184; VGA_G <= 8'd93; VGA_B <= 8'd177; end
			8'd190: begin VGA_R <= 8'd102; VGA_G <= 8'd51; VGA_B <= 8'd98; end
			8'd191: begin VGA_R <= 8'd244; VGA_G <= 8'd124; VGA_B <= 8'd238; end
			8'd192: begin VGA_R <= 8'd223; VGA_G <= 8'd113; VGA_B <= 8'd217; end
			8'd193: begin VGA_R <= 8'd254; VGA_G <= 8'd255; VGA_B <= 8'd133; end
			8'd194: begin VGA_R <= 8'd151; VGA_G <= 8'd145; VGA_B <= 8'd37; end
			8'd195: begin VGA_R <= 8'd255; VGA_G <= 8'd85; VGA_B <= 8'd85; end
			8'd196: begin VGA_R <= 8'd105; VGA_G <= 8'd255; VGA_B <= 8'd85; end
			8'd197: begin VGA_R <= 8'd30; VGA_G <= 8'd255; VGA_B <= 8'd0; end
			8'd198: begin VGA_R <= 8'd21; VGA_G <= 8'd182; VGA_B <= 8'd0; end
			8'd199: begin VGA_R <= 8'd2; VGA_G <= 8'd25; VGA_B <= 8'd100; end
			8'd200: begin VGA_R <= 8'd165; VGA_G <= 8'd83; VGA_B <= 8'd159; end
			8'd201: begin VGA_R <= 8'd249; VGA_G <= 8'd177; VGA_B <= 8'd180; end
			8'd202: begin VGA_R <= 8'd240; VGA_G <= 8'd60; VGA_B <= 8'd67; end
			8'd203: begin VGA_R <= 8'd255; VGA_G <= 8'd5; VGA_B <= 8'd5; end
			8'd204: begin VGA_R <= 8'd255; VGA_G <= 8'd48; VGA_B <= 8'd48; end
			8'd205: begin VGA_R <= 8'd255; VGA_G <= 8'd34; VGA_B <= 8'd34; end
			8'd206: begin VGA_R <= 8'd255; VGA_G <= 8'd68; VGA_B <= 8'd68; end
						
		endcase
		
		else if(isKid) begin VGA_R <= 8'd92; VGA_B <= 8'd82; VGA_G <= 8'd56; end
		
		else begin VGA_R <= 8'd0; VGA_B <= 8'd255; VGA_G <= 8'd255; end
		
	end
	
	
	
//	always_ff @ (posedge Clk) begin
//	
//		if(sram_read_ready)
//			
//		case(palette_idx)
//		
//			8'd0: begin VGA_R <= 8'd64; VGA_G <= 8'd128; VGA_B <= 8'd0; end
//			8'd1: begin VGA_R <= 8'd8; VGA_G <= 8'd0; VGA_B <= 8'd0; end
//			8'd2: begin VGA_R <= 8'd100; VGA_G <= 8'd0; VGA_B <= 8'd0; end
//			8'd3: begin VGA_R <= 8'd243; VGA_G <= 8'd0; VGA_B <= 8'd0; end
//			8'd4: begin VGA_R <= 8'd243; VGA_G <= 8'd91; VGA_B <= 8'd91; end
//			8'd5: begin VGA_R <= 8'd20; VGA_G <= 8'd20; VGA_B <= 8'd20; end
//			8'd6: begin VGA_R <= 8'd38; VGA_G <= 8'd38; VGA_B <= 8'd38; end
//			8'd7: begin VGA_R <= 8'd34; VGA_G <= 8'd34; VGA_B <= 8'd34; end
//			8'd8: begin VGA_R <= 8'd19; VGA_G <= 8'd19; VGA_B <= 8'd19; end
//			8'd9: begin VGA_R <= 8'd0; VGA_G <= 8'd0; VGA_B <= 8'd0; end
//			8'd10: begin VGA_R <= 8'd90; VGA_G <= 8'd39; VGA_B <= 8'd18; end
//			8'd11: begin VGA_R <= 8'd255; VGA_G <= 8'd199; VGA_B <= 8'd143; end
//			8'd12: begin VGA_R <= 8'd17; VGA_G <= 8'd26; VGA_B <= 8'd143; end
//			8'd13: begin VGA_R <= 8'd171; VGA_G <= 8'd0; VGA_B <= 8'd0; end
//			8'd14: begin VGA_R <= 8'd136; VGA_G <= 8'd6; VGA_B <= 8'd6; end
//			8'd15: begin VGA_R <= 8'd30; VGA_G <= 8'd30; VGA_B <= 8'd30; end
//			8'd16: begin VGA_R <= 8'd255; VGA_G <= 8'd255; VGA_B <= 8'd0; end
//			8'd17: begin VGA_R <= 8'd121; VGA_G <= 8'd192; VGA_B <= 8'd206; end
//			8'd18: begin VGA_R <= 8'd204; VGA_G <= 8'd234; VGA_B <= 8'd239; end
//			8'd19: begin VGA_R <= 8'd255; VGA_G <= 8'd255; VGA_B <= 8'd255; end
//			8'd20: begin VGA_R <= 8'd217; VGA_G <= 8'd237; VGA_B <= 8'd241; end
//			8'd21: begin VGA_R <= 8'd136; VGA_G <= 8'd170; VGA_B <= 8'd209; end
//			8'd22: begin VGA_R <= 8'd253; VGA_G <= 8'd254; VGA_B <= 8'd254; end
//			8'd23: begin VGA_R <= 8'd123; VGA_G <= 8'd190; VGA_B <= 8'd206; end
//			8'd24: begin VGA_R <= 8'd206; VGA_G <= 8'd235; VGA_B <= 8'd240; end
//			8'd25: begin VGA_R <= 8'd3; VGA_G <= 8'd3; VGA_B <= 8'd3; end
//			8'd26: begin VGA_R <= 8'd63; VGA_G <= 8'd6; VGA_B <= 8'd6; end
//			8'd27: begin VGA_R <= 8'd21; VGA_G <= 8'd66; VGA_B <= 8'd105; end
//			8'd28: begin VGA_R <= 8'd34; VGA_G <= 8'd125; VGA_B <= 8'd0; end
//			8'd29: begin VGA_R <= 8'd77; VGA_G <= 8'd224; VGA_B <= 8'd19; end
//			8'd30: begin VGA_R <= 8'd52; VGA_G <= 8'd188; VGA_B <= 8'd0; end
//			8'd31: begin VGA_R <= 8'd106; VGA_G <= 8'd80; VGA_B <= 8'd16; end
//			8'd32: begin VGA_R <= 8'd10; VGA_G <= 8'd3; VGA_B <= 8'd0; end
//			8'd33: begin VGA_R <= 8'd161; VGA_G <= 8'd138; VGA_B <= 8'd50; end
//			8'd34: begin VGA_R <= 8'd214; VGA_G <= 8'd202; VGA_B <= 8'd190; end
//			8'd35: begin VGA_R <= 8'd195; VGA_G <= 8'd215; VGA_B <= 8'd247; end
//			8'd36: begin VGA_R <= 8'd75; VGA_G <= 8'd75; VGA_B <= 8'd75; end
//			8'd37: begin VGA_R <= 8'd151; VGA_G <= 8'd151; VGA_B <= 8'd151; end
//			8'd38: begin VGA_R <= 8'd213; VGA_G <= 8'd213; VGA_B <= 8'd213; end
//			8'd39: begin VGA_R <= 8'd235; VGA_G <= 8'd235; VGA_B <= 8'd235; end
//			8'd40: begin VGA_R <= 8'd0; VGA_G <= 8'd192; VGA_B <= 8'd192; end
//			8'd41: begin VGA_R <= 8'd12; VGA_G <= 8'd12; VGA_B <= 8'd12; end
//			8'd42: begin VGA_R <= 8'd29; VGA_G <= 8'd42; VGA_B <= 8'd13; end
//			8'd43: begin VGA_R <= 8'd55; VGA_G <= 8'd90; VGA_B <= 8'd16; end
//			8'd44: begin VGA_R <= 8'd78; VGA_G <= 8'd132; VGA_B <= 8'd18; end
//			8'd45: begin VGA_R <= 8'd79; VGA_G <= 8'd133; VGA_B <= 8'd18; end
//			8'd46: begin VGA_R <= 8'd79; VGA_G <= 8'd132; VGA_B <= 8'd19; end
//			8'd47: begin VGA_R <= 8'd57; VGA_G <= 8'd94; VGA_B <= 8'd14; end
//			8'd48: begin VGA_R <= 8'd81; VGA_G <= 8'd132; VGA_B <= 8'd20; end
//			8'd49: begin VGA_R <= 8'd15; VGA_G <= 8'd15; VGA_B <= 8'd13; end
//			8'd50: begin VGA_R <= 8'd83; VGA_G <= 8'd132; VGA_B <= 8'd22; end
//			8'd51: begin VGA_R <= 8'd83; VGA_G <= 8'd140; VGA_B <= 8'd19; end
//			8'd52: begin VGA_R <= 8'd84; VGA_G <= 8'd132; VGA_B <= 8'd24; end
//			8'd53: begin VGA_R <= 8'd86; VGA_G <= 8'd132; VGA_B <= 8'd25; end
//			8'd54: begin VGA_R <= 8'd87; VGA_G <= 8'd150; VGA_B <= 8'd16; end
//			8'd55: begin VGA_R <= 8'd90; VGA_G <= 8'd150; VGA_B <= 8'd20; end
//			8'd56: begin VGA_R <= 8'd87; VGA_G <= 8'd147; VGA_B <= 8'd19; end
//			8'd57: begin VGA_R <= 8'd87; VGA_G <= 8'd132; VGA_B <= 8'd27; end
//			8'd58: begin VGA_R <= 8'd60; VGA_G <= 8'd101; VGA_B <= 8'd14; end
//			8'd59: begin VGA_R <= 8'd88; VGA_G <= 8'd132; VGA_B <= 8'd28; end
//			8'd60: begin VGA_R <= 8'd82; VGA_G <= 8'd140; VGA_B <= 8'd15; end
//			8'd61: begin VGA_R <= 8'd76; VGA_G <= 8'd126; VGA_B <= 8'd17; end
//			8'd62: begin VGA_R <= 8'd77; VGA_G <= 8'd129; VGA_B <= 8'd17; end
//			8'd63: begin VGA_R <= 8'd85; VGA_G <= 8'd146; VGA_B <= 8'd15; end
//			8'd64: begin VGA_R <= 8'd75; VGA_G <= 8'd126; VGA_B <= 8'd16; end
//			8'd65: begin VGA_R <= 8'd76; VGA_G <= 8'd127; VGA_B <= 8'd16; end
//			8'd66: begin VGA_R <= 8'd78; VGA_G <= 8'd127; VGA_B <= 8'd16; end
//			8'd67: begin VGA_R <= 8'd77; VGA_G <= 8'd127; VGA_B <= 8'd17; end
//			8'd68: begin VGA_R <= 8'd79; VGA_G <= 8'd127; VGA_B <= 8'd19; end
//			8'd69: begin VGA_R <= 8'd77; VGA_G <= 8'd133; VGA_B <= 8'd13; end
//			8'd70: begin VGA_R <= 8'd74; VGA_G <= 8'd127; VGA_B <= 8'd14; end
//			8'd71: begin VGA_R <= 8'd73; VGA_G <= 8'd126; VGA_B <= 8'd14; end
//			8'd72: begin VGA_R <= 8'd74; VGA_G <= 8'd126; VGA_B <= 8'd13; end
//			8'd73: begin VGA_R <= 8'd82; VGA_G <= 8'd130; VGA_B <= 8'd23; end
//			8'd74: begin VGA_R <= 8'd27; VGA_G <= 8'd26; VGA_B <= 8'd19; end
//			8'd75: begin VGA_R <= 8'd73; VGA_G <= 8'd127; VGA_B <= 8'd12; end
//			8'd76: begin VGA_R <= 8'd80; VGA_G <= 8'd127; VGA_B <= 8'd21; end
//			8'd77: begin VGA_R <= 8'd81; VGA_G <= 8'd129; VGA_B <= 8'd21; end
//			8'd78: begin VGA_R <= 8'd82; VGA_G <= 8'd128; VGA_B <= 8'd23; end
//			8'd79: begin VGA_R <= 8'd79; VGA_G <= 8'd138; VGA_B <= 8'd12; end
//			8'd80: begin VGA_R <= 8'd83; VGA_G <= 8'd129; VGA_B <= 8'd25; end
//			8'd81: begin VGA_R <= 8'd40; VGA_G <= 8'd40; VGA_B <= 8'd40; end
//			8'd82: begin VGA_R <= 8'd89; VGA_G <= 8'd132; VGA_B <= 8'd29; end
//			8'd83: begin VGA_R <= 8'd90; VGA_G <= 8'd132; VGA_B <= 8'd28; end
//			8'd84: begin VGA_R <= 8'd89; VGA_G <= 8'd132; VGA_B <= 8'd31; end
//			8'd85: begin VGA_R <= 8'd90; VGA_G <= 8'd132; VGA_B <= 8'd30; end
//			8'd86: begin VGA_R <= 8'd92; VGA_G <= 8'd132; VGA_B <= 8'd32; end
//			8'd87: begin VGA_R <= 8'd51; VGA_G <= 8'd86; VGA_B <= 8'd12; end
//			8'd88: begin VGA_R <= 8'd93; VGA_G <= 8'd132; VGA_B <= 8'd34; end
//			8'd89: begin VGA_R <= 8'd100; VGA_G <= 8'd141; VGA_B <= 8'd38; end
//			8'd90: begin VGA_R <= 8'd99; VGA_G <= 8'd140; VGA_B <= 8'd37; end
//			8'd91: begin VGA_R <= 8'd97; VGA_G <= 8'd138; VGA_B <= 8'd35; end
//			8'd92: begin VGA_R <= 8'd95; VGA_G <= 8'd136; VGA_B <= 8'd36; end
//			8'd93: begin VGA_R <= 8'd98; VGA_G <= 8'd139; VGA_B <= 8'd37; end
//			8'd94: begin VGA_R <= 8'd101; VGA_G <= 8'd141; VGA_B <= 8'd39; end
//			8'd95: begin VGA_R <= 8'd103; VGA_G <= 8'd141; VGA_B <= 8'd40; end
//			8'd96: begin VGA_R <= 8'd94; VGA_G <= 8'd134; VGA_B <= 8'd36; end
//			8'd97: begin VGA_R <= 8'd84; VGA_G <= 8'd127; VGA_B <= 8'd26; end
//			8'd98: begin VGA_R <= 8'd82; VGA_G <= 8'd127; VGA_B <= 8'd26; end
//			8'd99: begin VGA_R <= 8'd87; VGA_G <= 8'd129; VGA_B <= 8'd28; end
//			8'd100: begin VGA_R <= 8'd98; VGA_G <= 8'd141; VGA_B <= 8'd35; end
//			8'd101: begin VGA_R <= 8'd85; VGA_G <= 8'd127; VGA_B <= 8'd28; end
//			8'd102: begin VGA_R <= 8'd92; VGA_G <= 8'd134; VGA_B <= 8'd32; end
//			8'd103: begin VGA_R <= 8'd89; VGA_G <= 8'd145; VGA_B <= 8'd21; end
//			8'd104: begin VGA_R <= 8'd90; VGA_G <= 8'd134; VGA_B <= 8'd31; end
//			8'd105: begin VGA_R <= 8'd96; VGA_G <= 8'd138; VGA_B <= 8'd33; end
//			8'd106: begin VGA_R <= 8'd92; VGA_G <= 8'd150; VGA_B <= 8'd22; end
//			8'd107: begin VGA_R <= 8'd91; VGA_G <= 8'd136; VGA_B <= 8'd31; end
//			8'd108: begin VGA_R <= 8'd95; VGA_G <= 8'd141; VGA_B <= 8'd32; end
//			8'd109: begin VGA_R <= 8'd96; VGA_G <= 8'd141; VGA_B <= 8'd34; end
//			8'd110: begin VGA_R <= 8'd87; VGA_G <= 8'd141; VGA_B <= 8'd21; end
//			8'd111: begin VGA_R <= 8'd92; VGA_G <= 8'd138; VGA_B <= 8'd31; end
//			8'd112: begin VGA_R <= 8'd97; VGA_G <= 8'd141; VGA_B <= 8'd33; end
//			8'd113: begin VGA_R <= 8'd93; VGA_G <= 8'd147; VGA_B <= 8'd26; end
//			8'd114: begin VGA_R <= 8'd90; VGA_G <= 8'd141; VGA_B <= 8'd26; end
//			8'd115: begin VGA_R <= 8'd94; VGA_G <= 8'd150; VGA_B <= 8'd25; end
//			8'd116: begin VGA_R <= 8'd94; VGA_G <= 8'd141; VGA_B <= 8'd31; end
//			8'd117: begin VGA_R <= 8'd91; VGA_G <= 8'd138; VGA_B <= 8'd28; end
//			8'd118: begin VGA_R <= 8'd89; VGA_G <= 8'd134; VGA_B <= 8'd27; end
//			8'd119: begin VGA_R <= 8'd95; VGA_G <= 8'd149; VGA_B <= 8'd27; end
//			8'd120: begin VGA_R <= 8'd65; VGA_G <= 8'd101; VGA_B <= 8'd20; end
//			8'd121: begin VGA_R <= 8'd86; VGA_G <= 8'd127; VGA_B <= 8'd29; end
//			8'd122: begin VGA_R <= 8'd93; VGA_G <= 8'd141; VGA_B <= 8'd29; end
//			8'd123: begin VGA_R <= 8'd96; VGA_G <= 8'd149; VGA_B <= 8'd28; end
//			8'd124: begin VGA_R <= 8'd93; VGA_G <= 8'd141; VGA_B <= 8'd27; end
//			8'd125: begin VGA_R <= 8'd95; VGA_G <= 8'd137; VGA_B <= 8'd32; end
//			8'd126: begin VGA_R <= 8'd92; VGA_G <= 8'd141; VGA_B <= 8'd28; end
//			8'd127: begin VGA_R <= 8'd74; VGA_G <= 8'd128; VGA_B <= 8'd11; end
//			8'd128: begin VGA_R <= 8'd63; VGA_G <= 8'd95; VGA_B <= 8'd22; end
//			8'd129: begin VGA_R <= 8'd20; VGA_G <= 8'd19; VGA_B <= 8'd14; end
//			8'd130: begin VGA_R <= 8'd90; VGA_G <= 8'd144; VGA_B <= 8'd25; end
//			8'd131: begin VGA_R <= 8'd77; VGA_G <= 8'd132; VGA_B <= 8'd16; end
//			8'd132: begin VGA_R <= 8'd114; VGA_G <= 8'd102; VGA_B <= 8'd69; end
//			8'd133: begin VGA_R <= 8'd79; VGA_G <= 8'd135; VGA_B <= 8'd15; end
//			8'd134: begin VGA_R <= 8'd117; VGA_G <= 8'd105; VGA_B <= 8'd71; end
//			8'd135: begin VGA_R <= 8'd116; VGA_G <= 8'd104; VGA_B <= 8'd71; end
//			8'd136: begin VGA_R <= 8'd93; VGA_G <= 8'd84; VGA_B <= 8'd57; end
//			8'd137: begin VGA_R <= 8'd111; VGA_G <= 8'd99; VGA_B <= 8'd67; end
//			8'd138: begin VGA_R <= 8'd107; VGA_G <= 8'd96; VGA_B <= 8'd65; end
//			8'd139: begin VGA_R <= 8'd90; VGA_G <= 8'd80; VGA_B <= 8'd55; end
//			8'd140: begin VGA_R <= 8'd91; VGA_G <= 8'd81; VGA_B <= 8'd55; end
//			8'd141: begin VGA_R <= 8'd118; VGA_G <= 8'd105; VGA_B <= 8'd72; end
//			8'd142: begin VGA_R <= 8'd88; VGA_G <= 8'd79; VGA_B <= 8'd53; end
//			8'd143: begin VGA_R <= 8'd87; VGA_G <= 8'd78; VGA_B <= 8'd53; end
//			8'd144: begin VGA_R <= 8'd115; VGA_G <= 8'd103; VGA_B <= 8'd70; end
//			8'd145: begin VGA_R <= 8'd125; VGA_G <= 8'd112; VGA_B <= 8'd76; end
//			8'd146: begin VGA_R <= 8'd89; VGA_G <= 8'd80; VGA_B <= 8'd54; end
//			8'd147: begin VGA_R <= 8'd86; VGA_G <= 8'd77; VGA_B <= 8'd52; end
//			8'd148: begin VGA_R <= 8'd122; VGA_G <= 8'd109; VGA_B <= 8'd74; end
//			8'd149: begin VGA_R <= 8'd84; VGA_G <= 8'd75; VGA_B <= 8'd51; end
//			8'd150: begin VGA_R <= 8'd85; VGA_G <= 8'd76; VGA_B <= 8'd52; end
//			8'd151: begin VGA_R <= 8'd109; VGA_G <= 8'd97; VGA_B <= 8'd66; end
//			8'd152: begin VGA_R <= 8'd100; VGA_G <= 8'd90; VGA_B <= 8'd61; end
//			8'd153: begin VGA_R <= 8'd8; VGA_G <= 8'd7; VGA_B <= 8'd3; end
//			8'd154: begin VGA_R <= 8'd119; VGA_G <= 8'd106; VGA_B <= 8'd72; end
//			8'd155: begin VGA_R <= 8'd83; VGA_G <= 8'd74; VGA_B <= 8'd51; end
//			8'd156: begin VGA_R <= 8'd67; VGA_G <= 8'd60; VGA_B <= 8'd41; end
//			8'd157: begin VGA_R <= 8'd130; VGA_G <= 8'd116; VGA_B <= 8'd79; end
//			8'd158: begin VGA_R <= 8'd95; VGA_G <= 8'd85; VGA_B <= 8'd58; end
//			8'd159: begin VGA_R <= 8'd133; VGA_G <= 8'd119; VGA_B <= 8'd80; end
//			8'd160: begin VGA_R <= 8'd136; VGA_G <= 8'd122; VGA_B <= 8'd82; end
//			8'd161: begin VGA_R <= 8'd82; VGA_G <= 8'd73; VGA_B <= 8'd50; end
//			8'd162: begin VGA_R <= 8'd99; VGA_G <= 8'd88; VGA_B <= 8'd60; end
//			8'd163: begin VGA_R <= 8'd139; VGA_G <= 8'd124; VGA_B <= 8'd84; end
//			8'd164: begin VGA_R <= 8'd132; VGA_G <= 8'd118; VGA_B <= 8'd80; end
//			8'd165: begin VGA_R <= 8'd45; VGA_G <= 8'd40; VGA_B <= 8'd27; end
//			8'd166: begin VGA_R <= 8'd97; VGA_G <= 8'd87; VGA_B <= 8'd59; end
//			8'd167: begin VGA_R <= 8'd131; VGA_G <= 8'd117; VGA_B <= 8'd79; end
//			8'd168: begin VGA_R <= 8'd80; VGA_G <= 8'd72; VGA_B <= 8'd49; end
//			8'd169: begin VGA_R <= 8'd92; VGA_G <= 8'd75; VGA_B <= 8'd21; end
//			8'd170: begin VGA_R <= 8'd89; VGA_G <= 8'd72; VGA_B <= 8'd20; end
//			8'd171: begin VGA_R <= 8'd102; VGA_G <= 8'd92; VGA_B <= 8'd62; end
//			8'd172: begin VGA_R <= 8'd137; VGA_G <= 8'd122; VGA_B <= 8'd83; end
//			8'd173: begin VGA_R <= 8'd127; VGA_G <= 8'd114; VGA_B <= 8'd77; end
//			8'd174: begin VGA_R <= 8'd83; VGA_G <= 8'd68; VGA_B <= 8'd19; end
//			8'd175: begin VGA_R <= 8'd78; VGA_G <= 8'd64; VGA_B <= 8'd18; end
//			8'd176: begin VGA_R <= 8'd140; VGA_G <= 8'd125; VGA_B <= 8'd84; end
//			8'd177: begin VGA_R <= 8'd16; VGA_G <= 8'd13; VGA_B <= 8'd4; end
//			8'd178: begin VGA_R <= 8'd72; VGA_G <= 8'd59; VGA_B <= 8'd17; end
//			8'd179: begin VGA_R <= 8'd118; VGA_G <= 8'd106; VGA_B <= 8'd71; end
//			8'd180: begin VGA_R <= 8'd104; VGA_G <= 8'd93; VGA_B <= 8'd63; end
//			8'd181: begin VGA_R <= 8'd87; VGA_G <= 8'd71; VGA_B <= 8'd20; end
//			8'd182: begin VGA_R <= 8'd106; VGA_G <= 8'd94; VGA_B <= 8'd64; end
//			8'd183: begin VGA_R <= 8'd92; VGA_G <= 8'd82; VGA_B <= 8'd56; end
//			// yellow
//			8'd184: begin VGA_R <= 8'hff; VGA_G <= 8'hff; VGA_B <= 8'h00; end
//		endcase
//		
//		else if(isKid) begin VGA_R <= 8'd92; VGA_B <= 8'd82; VGA_G <= 8'd56; end
//		
//		else begin VGA_R <= 8'd0; VGA_B <= 8'd255; VGA_G <= 8'd255; end
//	end

endmodule
