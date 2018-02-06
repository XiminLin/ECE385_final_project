//our character will have 
module bullet_set(
		input logic frame_clk,
		input logic shoot,
		input logic Reset,
		input logic direction,
		input logic hit,
		input logic [9:0] PositionX, PositionY,
		input logic [9:0] DrawX_write, DrawY_write,
		output logic [9:0] Bullet_X, 
		output logic [9:0] Bullet_Y, 
		output logic isBullet,
		output logic [24:0] Bullet_address

);

	
	bullet bullet_1(.frame_clk,
						.shoot,
						.Reset,
						.hit,
						.direction,
						.PositionX, .PositionY,
						.DrawX_write,.DrawY_write,
						.Bullet_X(Bullet_X),.Bullet_Y(Bullet_Y),
						.isBullet,.Bullet_address);
	
endmodule


module bullet(
		input logic frame_clk,
		input logic shoot, //the bullet will start when it receive the signal
		input logic Reset, 
		input logic direction,
		input logic hit, //the bullet should disappear when it hit something
		input logic [9:0] PositionX, PositionY, //the starting point of our bullet, should be the position of character
		input logic [9:0] DrawX_write, DrawY_write,
		output logic [9:0] Bullet_X, Bullet_Y, //used to determine whether we have hit the boss 
		output logic isBullet,
		output logic [24:0] Bullet_address
);

	parameter [9:0] speed = 10'd20; //speed of the bullet
	logic [9:0] starting_X, starting_Y;
	logic [9:0] end_X, end_Y;
	enum logic [3:0] {ready, flying} state, next_state;

	assign end_X = Bullet_X + 10'd1;
	assign end_Y = Bullet_Y + 10'd1;
	logic direction_fixed, direction_in;
	logic [9:0] Bullet_X_in, Bullet_Y_in;
	always_ff @ (posedge frame_clk)
	begin
		state <= next_state;
		if(Reset == 1'b1)
			state <= ready;
		Bullet_X <= Bullet_X_in;
		Bullet_Y <= Bullet_Y_in;
		direction_fixed <= direction_in;
	end
	
	
	
	always_comb
	begin
		next_state = state; //default case
		case(state)
			ready:
			begin
				if(shoot == 1'b1) //if we receive the shoot signal, the bullet will begin to move
					next_state = flying;
			end
			flying:
			begin
				if(hit == 1'b1 || Bullet_X > 10'd639) //it will disappear when it hit the boundary
					next_state = ready;
			end
		endcase
	
		Bullet_address = 25'd0;
		isBullet = 1'b0;
		Bullet_X_in = starting_X;
		direction_in = direction_fixed;
		Bullet_Y_in = 10'd500; //normally we do not want it to hit anything
		starting_X = PositionX + 10'd31;
		if(~direction)
			starting_X = PositionX;
		starting_Y = PositionY + 10'd17;
		case(state)
			ready: //at ready state, the bullet is in the gun
				if(shoot == 1'b1)
				begin
					Bullet_Y_in = starting_Y;
					direction_in = direction;
				end
			flying: 
			begin
				if((DrawX_write == Bullet_X || DrawX_write == end_X) && (DrawY_write == Bullet_Y || DrawY_write == end_Y))
				begin
					isBullet = 1'b1;
					Bullet_address = 25'd1;
				end
				Bullet_Y_in = Bullet_Y;
				if(direction_fixed)
					Bullet_X_in = Bullet_X + speed;
				else if(~direction_fixed)
					Bullet_X_in = Bullet_X - speed;
			end
		endcase
	end
	




endmodule 