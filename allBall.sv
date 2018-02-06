module allBall(//input logic Clock_50,
				input logic frame_clk,
				input logic Reset_h,
				input logic moreBall,
				input logic [9:0] DrawX, DrawY,
				input logic [9:0] Boss_position_X, Boss_position_Y,
				input logic [9:0] Kid_position_X, Kid_position_Y,
				output logic isBall,
				output logic hitBall,
				output logic [24:0] Ball_address
				);
				
	int counter, counter_in;
	logic hitBall_in;
	logic isBall_in;
	logic [24:0] Ball_address_in;
	
//	assign Ball_address = Ball_address_in;
//	assign isBall = isBall_in;
	
	parameter logic [9:0] initial_X = 10'd30;
	parameter logic [9:0] initial_Y = 10'd30;
	
	logic enable;
	logic done0, done1, done2, done3, done4;
	logic isBall0, isBall1, isBall2, isBall3, isBall4;
	logic hitBall0, hitBall1, hitBall2, hitBall3, hitBall4;
	
	logic [9:0] init_move_X0, init_move_Y0;
	logic [9:0] init_move_X1, init_move_Y1;
	logic [9:0] init_move_X2, init_move_Y2;
	logic [9:0] init_move_X3, init_move_Y3;
	logic [9:0] init_move_X4, init_move_Y4;
	
	assign init_move_X0 = ~(10'd4) + 10'd1;
	assign init_move_Y0 = ~(10'd10) + 10'd1;
	
	assign init_move_X1 = ~(10'd4) + 10'd1;
	assign init_move_Y1 = ~(10'd8) + 10'd1;
	
	assign init_move_X2 = ~(10'd4) + 10'd1;
	assign init_move_Y2 = ~(10'd4) + 10'd1;
	
	assign init_move_X3 = ~(10'd8) + 10'd1;
	assign init_move_Y3 = ~(10'd4) + 10'd1;
	
	assign init_move_X4 = ~(10'd10) + 10'd1;
	assign init_move_Y4 = ~(10'd4) + 10'd1;
	
	logic [24:0] BA0, BA1, BA2, BA3, BA4;
	
	enum logic [1:0] {noBall, sendBall, stopBall} curr_state, next_state;
//	enum logic [1:0] {noBall, oneBall, twoBall, threeBall} curr_state, next_state;
	
	ball b0(.*, .enable(enable), .initial_X(Boss_position_X), .initial_Y(Boss_position_Y), .init_move_X(init_move_X0), .init_move_Y(init_move_Y0), .size(10'd10), .isBall(isBall0), .hitBall(hitBall0), .done(done0), .Ball_address(BA0) );
	ball b1(.*, .enable(enable), .initial_X(Boss_position_X), .initial_Y(Boss_position_Y), .init_move_X(init_move_X1), .init_move_Y(init_move_Y1), .size(10'd10), .isBall(isBall1), .hitBall(hitBall1), .done(done1), .Ball_address(BA1) );
	ball b2(.*, .enable(enable), .initial_X(Boss_position_X), .initial_Y(Boss_position_Y), .init_move_X(init_move_X2), .init_move_Y(init_move_Y2), .size(10'd10), .isBall(isBall2), .hitBall(hitBall2), .done(done2), .Ball_address(BA2) );

	ball b3(.*, .enable(enable), .initial_X(Boss_position_X), .initial_Y(Boss_position_Y), .init_move_X(init_move_X3), .init_move_Y(init_move_Y3), .size(10'd10), .isBall(isBall3), .hitBall(hitBall3), .done(done3), .Ball_address(BA3) );

	ball b4(.*, .enable(enable), .initial_X(Boss_position_X), .initial_Y(Boss_position_Y), .init_move_X(init_move_X4), .init_move_Y(init_move_Y4), .size(10'd10), .isBall(isBall4), .hitBall(hitBall4), .done(done4), .Ball_address(BA4) );
	
	 
	always_ff @ (posedge frame_clk) begin
		if(Reset_h) begin
			curr_state <= noBall;
			counter <= 0;
			hitBall <= 1'b0;
		end
		else begin
			curr_state <= next_state;
			counter <= counter_in;
			hitBall <= hitBall_in;
		end
	end
	
//	always_ff @ (posedge Clock_50) begin
//		if(Reset_h) begin
//			isBall <= 1'b0;
//			Ball_address <= 25'd0;
//		end
//		else begin
//			isBall <= isBall_in;
//			Ball_address <= Ball_address_in;
//		end
//	end
	
	always_comb begin
		next_state = curr_state;
		counter_in =  counter;
		enable = 1'b0;
		isBall = 1'b0;
		hitBall_in = 1'b0;
		Ball_address = 25'd0;
		case(curr_state)
			
			noBall: begin
				if(moreBall) begin
					next_state = sendBall;
					enable = 1'b1;
					counter_in = 300;
				end
			end
			
			sendBall: begin
				isBall = isBall0 | isBall1 | isBall2 | isBall3 | isBall4;
				hitBall_in = hitBall0 | hitBall1 | hitBall2 | hitBall3 | hitBall4;
				Ball_address = 25'd0;
				if(isBall) begin
					Ball_address = 25'd1;
				end
				
//				Ball_address_in = BA0 | BA1 | BA2 | BA3 | BA4;
				if(counter == 0) begin
					counter_in = 300;
					next_state = noBall;
				end
				else begin
					counter_in = counter - 1;
				end
			end
		endcase
	end

endmodule




module ball(//input logic Clock_50,
			input logic Reset_h,
			input logic frame_clk,
			input logic enable,
			input logic [9:0] DrawX, DrawY,
			input logic [9:0] initial_X, initial_Y,
			input logic [9:0] init_move_X, init_move_Y,
			input logic [9:0] size,
			input logic [9:0] Kid_position_X, Kid_position_Y,
			output logic isBall,
			output logic hitBall,
			output logic done,
			output logic [24:0] Ball_address
			);
	
	logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	
	parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	
	logic hitBall_in;
	//logic [24:0] Ball_address_in;
	
    int DistX, DistY, Size;

	//logic isBall_in;
	
	int counter, counter_in;
	
	enum logic [1:0] {starting, alive, dead} curr_state, next_state;
	
	logic frame_clk_delayed;
    logic frame_clk_rising_edge;
	
//	always_ff @ (posedge Clock_50) begin
//		if(Reset_h) begin
//			isBall <= 1'b0;
//			Ball_address <= 25'd0;
//		end
//		else begin
//			isBall <= isBall_in;
//			Ball_address <= Ball_address_in;
//		end
//	end
	
//    always_ff @ (posedge Clock_50) begin
//        frame_clk_delayed <= frame_clk;
//    end
//    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	
    always_ff @ (posedge frame_clk)
    begin
        if (Reset_h) begin
			counter <= 0;
			curr_state <= dead;
            Ball_X_Pos <= initial_X;
            Ball_Y_Pos <= initial_Y;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
			hitBall <= 1'b0;
        end
//        else if (frame_clk_rising_edge) begin       // Update only at rising edge of frame clock
		else begin
			counter <= counter_in;
			curr_state <= next_state;
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <=  Ball_X_Motion_in;
            Ball_Y_Motion <=  Ball_Y_Motion_in;
			hitBall <= hitBall_in;
        end
        // By defualt, keep the register values.
    end
	
	always_comb begin
		next_state = curr_state;
		Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
		Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
		Ball_X_Motion_in = Ball_X_Motion;
		Ball_Y_Motion_in = Ball_Y_Motion;
		DistX = DrawX - Ball_X_Pos;
		DistY = DrawY - Ball_Y_Pos;
		Size = size;
		isBall = 1'b0;
		hitBall_in = 1'b0;
		Ball_address = 25'd0;
		counter_in = counter;
		done = 1'b0;
		case(curr_state)
		
			starting: begin
				next_state = alive;
				Ball_X_Pos_in = initial_X;
				Ball_Y_Pos_in = initial_Y;
				if(Kid_position_X + 10'd15 > initial_X) begin
					Ball_X_Motion_in = ~(init_move_X) + 10'd1;
				end
				else begin
					Ball_X_Motion_in = init_move_X;
				end
				if(Kid_position_Y + 10'd15 > initial_Y) begin
					Ball_Y_Motion_in = ~(init_move_Y) + 10'd1;
				end
				else begin
					Ball_Y_Motion_in = init_move_Y;
				end
				counter_in = 300;
			end
		
			alive: begin
				if( (DistX * DistX + DistY * DistY) <= (Size * Size) && curr_state == alive ) begin
					isBall = 1'b1;
					Ball_address = 25'd1;
				end
				if(Ball_X_Pos + size >= Kid_position_X && Ball_X_Pos - size <= Kid_position_X + 10'd32 && 
					Ball_Y_Pos >= Kid_position_Y && Ball_Y_Pos <= Kid_position_Y + 10'd32) begin
					hitBall_in = 1'b1;
				end
				if(Ball_Y_Pos + size >= Kid_position_Y && Ball_Y_Pos - size <= Kid_position_Y + 10'd32 &&
					Ball_X_Pos >= Kid_position_X && Ball_X_Pos <= Kid_position_X + 10'd32) begin
					hitBall_in = 1'b1;
				end
				if(counter == 0) begin
					next_state = dead;
				end
				else begin
					counter_in = counter - 1;
				end
			end
			
			dead: begin
				done = 1'b1;
				if(enable) begin
					next_state = starting;
				end
			end
		endcase
		
//		if( Ball_Y_Pos + Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//		begin
//			Ball_Y_Motion_in = initial_Y;  // 2's complement.
//		end
//		else if ( Ball_Y_Pos <= Ball_Y_Min + Size )  // Ball is at the top edge, BOUNCE!
//		begin
//			Ball_Y_Motion_in = (~(init_move_Y) + 1'b1);
//		end
//		if(Ball_X_Pos + Size >= Ball_X_Max )
//		begin
//			Ball_X_Motion_in = init_move_X;
//		end
//		else if (Ball_X_Pos  <= Ball_X_Min + Size )
//		begin
//			Ball_X_Motion_in = (~(init_move_X) + 1'b1);
//		end
		
	end
	
endmodule
