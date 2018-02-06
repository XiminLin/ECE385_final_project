module getKeycode(input logic Clock_50,
					input logic Reset_h,
					input logic [31:0] keycode,
					output logic space,W,A,D,R,S,Enter,Esc);
						
	always_ff @ (posedge Clock_50) begin
		if(Reset_h) begin
			space <= 1'b0;
			W <= 1'b0;
			A <= 1'b0;
			D <= 1'b0;
			S <= 1'b0;
			R <= 1'b0;
			Enter <= 1'b0;
			Esc <= 1'b0;
		end	
		else begin
			space <= (keycode[31:24] == 8'd44 || keycode[23:16] == 8'd44 || keycode[15:8] == 8'd44 || keycode[7:0] == 8'd44) ? 1'b1 : 1'b0;
			W <= (keycode[31:24] == 8'd26 || keycode[23:16] == 8'd26 || keycode[15:8] == 8'd26 || keycode[7:0] == 8'd26) ? 1'b1 : 1'b0;
			A <= (keycode[31:24] == 8'd4 || keycode[23:16] == 8'd4 || keycode[15:8] == 8'd4 || keycode[7:0] == 8'd4) ? 1'b1 : 1'b0;
			S <= (keycode[31:24] == 8'd22 || keycode[23:16] == 8'd22 || keycode[15:8] == 8'd22 || keycode[7:0] == 8'd22) ? 1'b1 : 1'b0;
			
			R <= (keycode[31:24] == 8'd21 || keycode[23:16] == 8'd21 || keycode[15:8] == 8'd21 || keycode[7:0] == 8'd21) ? 1'b1 : 1'b0;
			
			D <= (keycode[31:24] == 8'd7 || keycode[23:16] == 8'd7 || keycode[15:8] == 8'd7 || keycode[7:0] == 8'd7) ? 1'b1 : 1'b0;
			Enter <= (keycode[31:24] == 8'd40 || keycode[23:16] == 8'd40 || keycode[15:8] == 8'd40 || keycode[7:0] == 8'd40) ? 1'b1 : 1'b0;
			Esc <= (keycode[31:24] == 8'd41 || keycode[23:16] == 8'd41 || keycode[15:8] == 8'd41 || keycode[7:0] == 8'd41) ? 1'b1 : 1'b0;
		end
	end
						
						
						
endmodule
