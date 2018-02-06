module DoubleBuffer(input logic frame_clk,
					input logic [9:0] DrawX, DrawY,
					input logic [19:0] sram_write_addr,
					output logic [19:0] sram_read_address, 
										sram_write_address
					);
					
	logic state;
					
	int address, dX, dY;
	
	always_ff @ (negedge frame_clk) begin
		state <= ~state;
	end
	
	always_comb begin
		dX = DrawX;
		dY = DrawY;
		address = dX + dY*800 + 1;
		
		sram_read_address = {~state, address[18:0]};
		sram_write_address = {state, sram_write_addr[18:0]};
	end
					
endmodule
