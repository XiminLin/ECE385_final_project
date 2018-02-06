//this will be the interface for the SRAM
//we will try to mimic a 50MHz dual port memory by using 100MHz
//we assume the the operation is valid within 10ns
//Note: there is one cycle delay

//Question: Do we need a input signal to denote whether we want to write to the memory?
module SRAM_interface(
	input logic VGA_CLK,
	input logic Clk_50,
	//input logic push, //for test
	input logic Reset_h, //active high
	input logic [19:0] Read_ADDR, //the address we want to read
							 Write_ADDR, //the address we want to write
	input logic [15:0] Data_write,
	output logic SRAM_CE_N,
					 SRAM_OE_N,
					 SRAM_WE_N,
					 SRAM_UB_N, //lower byte
					 SRAM_LB_N,
	output logic [19:0] SRAM_ADDR,
	inout wire [15:0] SRAM_DQ,
	output logic Read_ready, //when Read_ready is high, we know we can read valid data 
	output logic [15:0] Data_read
);
	logic Clk;
	assign Clk = Clk_50;
	logic state; //1 is write state and 0 is read state
	//logic reset_state;
	
	tristate t1(.Clk,.tristate_output_enable(state),.Data_write,.Data_read,.Data(SRAM_DQ));
	

//	always_ff @ (negedge Clk_100)
//	begin
//		reset_state <= ~Clk_50;
//	end
	always_comb
	begin
	//default case for read state
		SRAM_CE_N = 1'b0;
		SRAM_OE_N = 1'b0;
		SRAM_UB_N = 1'b0;
		SRAM_LB_N = 1'b0;
		SRAM_WE_N = 1'b1;
		SRAM_ADDR = Read_ADDR;
		Read_ready = 1'b0;
		if(state == 1'b1) //write state
		begin
			SRAM_OE_N = 1'b1;
			SRAM_WE_N = 1'b0;
			SRAM_ADDR = Write_ADDR;
			Read_ready = 1'b1; //the data is read out after 1 cycle
		end
		
	end
	
	always_ff @ (posedge Clk)
	begin
		state <= ~state;
		if(Reset_h == 1'b1)
		begin
			if(VGA_CLK == 1'b0)
				state <= 1'b1; //state machine better to be initialized
			else
				state <= 1'b0;
		//	state<= ~reset_state;
		end
	end
endmodule 





//for the SRAM, we need the tristate buffer to connect to the data busmux
module tristate(
	input logic Clk,
	input logic tristate_output_enable,
	input logic [15:0] Data_write,
	output logic [15:0] Data_read,
	inout wire [15:0] Data
);

	logic [15:0] Data_write_buffer, Data_read_buffer;	

	always_ff @ (posedge Clk)
	begin
		Data_read_buffer <= Data;
		Data_write_buffer <= Data_write;
	end
	
	assign Data = tristate_output_enable ? Data_write_buffer : {16{1'bZ}};
	
	assign Data_read = Data_read_buffer;
	
endmodule
	