module Processor(input logic CLOCK_50,
				input  logic [3:0]  KEY,
				input  logic [17:0] SW, 
				output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
				// VGA Interface 
				output logic [7:0]  VGA_R,        //VGA Red 
									VGA_G,        //VGA Green
									VGA_B,        //VGA Blue
				output logic   VGA_CLK,      //VGA Clock
									VGA_SYNC_N,   //VGA Sync signal
									VGA_BLANK_N,  //VGA Blank signal
									VGA_VS,       //VGA virtical sync signal
									VGA_HS,       //VGA horizontal sync signal
				// CY7C67200 Interface
				inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
				output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
				output logic        OTG_CS_N,     //CY7C67200 Chip Select
									OTG_RD_N,     //CY7C67200 Write
									OTG_WR_N,     //CY7C67200 Read
									OTG_RST_N,    //CY7C67200 Reset
				input  logic        OTG_INT,      //CY7C67200 Interrupt

				// SDRAM Interface
				output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
				inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
				output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
				output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
				output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
									DRAM_CAS_N,   //SDRAM Column Address Strobe
									DRAM_CKE,     //SDRAM Clock Enable
									DRAM_WE_N,    //SDRAM Write Enable
									DRAM_CS_N,    //SDRAM Chip Select
									DRAM_CLK,     //SDRAM Clock)
				output logic sig_test,
				// SRAM Interface
				output logic [19:0] SRAM_ADDR,
				inout  wire  [15:0] SRAM_DQ,
				output logic VGA_test,
				output logic 	SRAM_CE_N, 
									SRAM_LB_N, 
									SRAM_OE_N, 
									SRAM_UB_N, 
									SRAM_WE_N,
				//FLASH
				output logic [22:0] FL_ADDR,
				output logic FL_CE_N,
				inout wire [7:0] FL_DQ,
				output logic FL_OE_N,
				output logic FL_RST_N,
				input logic FL_RY,
				output logic FL_WE_N,
				output logic FL_WP_N,
				
				//Audio
				input logic AUD_BCLK, AUD_ADCDAT, AUD_DACLRCK, AUD_ADCLRCK,
				output logic AUD_XCK, AUD_DACDAT, I2C_SDAT, I2C_SCLK
				
				);
	logic Reset_h;
	logic [1:0] hpi_address;
	logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs;
	logic [31:0] keycode;

	logic sdram_valid, sdram_read_n, sdram_cs;
	logic wait_request;
	logic [31:0] sdram_data_in, sdram_data_in_s;
	logic [24:0] sdram_address, sdram_address_s;
	
	logic [15:0] sram_data_in, sram_data_out;
	logic [19:0] sram_read_address, sram_write_address;
	logic sram_read_ready;
	logic new_frame;
	logic buffer_full;
	logic [9:0] DrawX_write, DrawY_write;
	logic [31:0] buffer_data;
	logic push;
	logic clk_100;
//	logic sdram_clk;
	logic [19:0]sram_write_addr;
	logic [9:0] DrawX, DrawY;
//	logic [24:0] Kid_address;
//	logic isKid;
	logic sdram_valid_s, sdram_read_n_s, wait_request_s, sdram_cs_s;
	logic clk_50;
	logic clk_50_lead;
	logic [24:0] Address;
	logic slow_clk;
	
	sync #(.N(1))key_sync(.Clk(CLOCK_50),.d(~KEY[1]),.q(Reset_h));

	
	HexDriver driver3(.In0(sram_data_in[15:12]), .Out0(HEX3) );
	HexDriver driver2(.In0(sram_data_in[11:8]), .Out0(HEX2) );
	HexDriver driver1(.In0(sram_data_in[7:4]), .Out0(HEX1) );
	HexDriver driver0(.In0(sram_data_in[3:0]), .Out0(HEX0) );
			
			
//	always_ff @ (posedge new_frame)
//	begin
//		status_clk <= ~status_clk;
//	end
	SOC system(
		.clk_clk(CLOCK_50),
		.reset_reset_n(1'b1),
		.clk_25_clk(VGA_CLK),
		.clk_50_clk(clk_50),
		.clk_50_lead_clk(clk_50_lead),
		//.clk_100_sdram_clk(sdram_clk),
		.keycode_export(keycode),
		.otg_hpi_address_export(hpi_address),
		.otg_hpi_data_in_port(hpi_data_in),
		.otg_hpi_data_out_port(hpi_data_out),
		.otg_hpi_cs_export(hpi_cs),
		.otg_hpi_r_export(hpi_r),
		.otg_hpi_w_export(hpi_w),
		.sdram_clk_clk(DRAM_CLK),
	   .sdram_control_address(sdram_address),
		.sdram_control_byteenable_n(4'b1111),  
		.sdram_control_chipselect(sdram_cs),    
		.sdram_control_writedata(32'h12345),     
		.sdram_control_read_n(sdram_read_n),        
		.sdram_control_write_n(1'b1),       
		.sdram_control_readdata(sdram_data_in),      
		.sdram_control_readdatavalid(sdram_valid), 
		.sdram_control_waitrequest(wait_request),
		.sdram_wire_addr(DRAM_ADDR), 
		.sdram_wire_ba(DRAM_BA),   
		.sdram_wire_cas_n(DRAM_CAS_N),
		.sdram_wire_cke(DRAM_CKE),  
		.sdram_wire_cs_n(DRAM_CS_N), 
		.sdram_wire_dq(DRAM_DQ),   
		.sdram_wire_dqm(DRAM_DQM),  
		.sdram_wire_ras_n(DRAM_RAS_N),
		.sdram_wire_we_n(DRAM_WE_N),
		.slow_clk_clk(slow_clk)
	);
	
	
	SRAM_interface sram_intf(
//		.Clk_100(clk_100),
		.Clk_50(clk_50),
		.VGA_CLK,
		//.push,
		// for testing
		.Reset_h(Reset_h), 				//active high
		
		.Read_ADDR(sram_read_address), //the address we want to read
		.Write_ADDR(sram_write_address), //the address we want to write
		.Data_write(sram_data_out),
		.SRAM_CE_N,
		.SRAM_OE_N,
		.SRAM_WE_N,
		.SRAM_UB_N,
		.SRAM_LB_N,
		.SRAM_ADDR,
		.SRAM_DQ,
		.Read_ready(sram_read_ready), //when Read_ready is high, we know we can read valid data 
		.Data_read(sram_data_in)
	);

	
	VGA_controller vga0(
		.Clk(clk_50),         // 50 MHz clock
        .Reset(Reset_h),        // Active-high reset signal
        .VGA_HS,      			// Horizontal sync pulse.  Active low
        .VGA_VS,      			// Vertical sync pulse.  Active low
        .VGA_CLK,     			// 25 MHz VGA clock input
        .VGA_BLANK_N, 			// Blanking interval indicator.  Active low.
        .VGA_SYNC_N,  			// Composite Sync signal.  Active low.  We don't use it in this lab, but the video DAC on the DE2 board requires an input for it.
        .DrawX,       			// horizontal coordinate
        .DrawY,       			// vertical coordinate
		  .new_frame,
		  .VGA_test
	);

	
	ColorMapper CMP(
		.Clk(VGA_CLK),
		.palette_idx(sram_data_in[7:0]),
		.sram_read_ready(sram_read_ready),
		.DrawX,.DrawY,
		.VGA_R,
		.VGA_G,
		.VGA_B
	);
	
	hpi_io_intf hpi_interface(
		.Clk(clk_50),
		.Reset(1'b0),
		.from_sw_address(hpi_address),
		.from_sw_data_in(hpi_data_in),
		.from_sw_data_out(hpi_data_out),
		.from_sw_r(hpi_r),
		.from_sw_w(hpi_w),
		.from_sw_cs(hpi_cs),
		.OTG_DATA(OTG_DATA),    
		.OTG_ADDR(OTG_ADDR),    
		.OTG_RD_N(OTG_RD_N),    
		.OTG_WR_N(OTG_WR_N),    
		.OTG_CS_N(OTG_CS_N),    
		.OTG_RST_N(OTG_RST_N)
	);

	DoubleBuffer ADDR(
		.frame_clk(new_frame),
		.DrawX,.DrawY,
		.sram_write_addr,
		.sram_read_address,
		.sram_write_address
	);

	print printer(
		.clk_100(clk_50),
		.Reset_h,
		.new_frame,
		.wait_request(wait_request),
		.buffer_full,
		.sdram_data_in(sdram_data_in),
		.sdram_address,
		.buffer_data,
		.push,
		.Address,
		.DrawX_write,
		.DrawY_write,
		.sdram_read_n,
		.sdram_valid(sdram_valid),
		.sdram_cs
	);

	sdram_buffer queue(.sram_read_ready,
							.new_frame,
							.CLOCK_100(clk_50),
							.Reset_h,
							.sdram_valid(push),
							.sdram_data_in(buffer_data),
							.sram_write_addr,
							.sram_data_out(sram_data_out),
							.full(buffer_full));

	logic [24:0] Address_0, Address_1, Address_2, Address_3, Address_4, Address_5;
	assign Address = Address_0 | Address_1 | Address_2 | Address_3 | Address_4 | Address_5;
	logic confirmed;
	logic [3:0] selected_stage;
	logic death1,death2;
	logic death;
	logic reach_final;
	logic saved_1,saved_2;
	assign death = death1 | death2;
	stage1 first_stage(
		.stage(stage_select),
		.death(death1),
		.Address(Address_1),
		.DrawX_write, .DrawY_write,
		.W(~KEY[0]|space),.A(~KEY[3]|A),.D(~KEY[2]|D),
		.Reset_h(first_stage_reset),
		.test_mode(SW[17]),
		.shoot(SW[3]|Enter),
		.frame_clk(new_frame),
		.reach_final,
		.saved(saved_1),
		.clk_50_shift(clk_50_lead)
	);
	
	stage0 title(
		.stage(stage_select),
		.Address(Address_0),
		.selected_stage,
		.confirmed,
		.frame_clk(new_frame),
		.DrawX_write,.DrawY_write,
		.W(~KEY[3]|W),.S(~KEY[2]|S),
		.Reset_h(SW[2]),
		.enter(SW[5]|Enter)
	);
	logic [15:0] LDATA, RDATA;
	
	logic INIT, INIT_FINISH, adc_full, data_over;
	logic [31:0] ADCDATA;
	
	audio_interface audio(
		.clk(clk_50),
		.reset(Reset_h),
		.LDATA(LDATA),.RDATA(RDATA),
		.INIT(INIT),.INIT_FINISH(INIT_FINISH),
		.adc_full(adc_full),
		.data_over(data_over),
		.AUD_MCLK(AUD_XCK),
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCDAT(AUD_ADCDAT),
		.AUD_DACDAT(AUD_DACDAT),
		.AUD_DACLRCK(AUD_DACLRCK), .AUD_ADCLRCK(AUD_ADCLRCK),
		.I2C_SDAT(I2C_SDAT),.I2C_SCLK(I2C_SCLK),
		.ADCDATA(ADCDATA)
	);
	
	logic victory;
	stage2 second_stage(
		.stage(stage_select),
		.Address(Address_2),
		.saved(saved_2),
		.death(death2),
		.victory,
		.DrawX_write, .DrawY_write,
		.W(~KEY[0]|space),.A(~KEY[3]|A),.D(~KEY[2]|D),
		.Reset_h(second_stage_reset),
		.test_mode(SW[17]),
		.shoot(SW[3]|Enter),
		.frame_clk(new_frame),
		.clk_50_shift(clk_50_lead)
	);
	
	logic finish_game;
	stage_final finals(
		.DrawX_write,.DrawY_write,
		.stage(stage_select),
		.Reset_h(final_stage_reset),
		.Address(Address_3),
		.finish_game,
		.clk_50_shift(clk_50_lead),
		.frame_clk(new_frame),
		.enter(SW[5]|space)
	);
	
	stage_death dead_state(
		.DrawX_write,.DrawY_write,
		.stage(stage_select),
		.Reset_h(dead_stage_reset),
		.Address(Address_4),
		.R(SW[0]|R),
		.collide(death),
		.frame_clk(new_frame),
		.clk_50_shift(clk_50_lead)
	);
	
	Flash_control flash(
		.slow_clk,
		.Clock_50(clk_50),
		.reset_h(SW[2]),
		.game_state(BGM),
		.data_over,
		.INIT,
		.INIT_FINISH,
		.FL_ADDR,
		.FL_CE_N,
		.FL_DQ,
		.FL_OE_N,
		.FL_RST_N,
		.FL_RY,
		.FL_WE_N,
		.FL_WP_N,
		.LDATA,
		.RDATA
	
	);
	
	logic Enter,space,W,S,A,D,R,Esc;
	getKeycode gk0(
		.Clock_50(clk_50),
		.Reset_h,
		.keycode,
		.space,.W,.S,.A,.D,.R,.Enter,.Esc
	);
	stage_exit SE(
		.DrawX_write,.DrawY_write,
		.stage(stage_select),
		.clk_50_shift(clk_50_lead),
		.Address(Address_5)
	
	);
	enum logic [3:0] {cover1, first , reset_first, second, reset_second, dead, final_report, professor} state, next_state;
	logic [1:0] record, BGM;
	logic [1:0] record_in, BGM_in;
	logic [3:0] stage_select, stage_select_in;
	logic first_stage_reset,first_stage_reset_in;
	logic second_stage_reset,second_stage_reset_in;
	logic final_stage_reset,final_stage_reset_in;
	logic dead_stage_reset,dead_stage_reset_in;
	always_ff @ (posedge new_frame)
	begin
		state <= next_state;
		record <= record_in;
		BGM <= BGM_in;
		first_stage_reset <= first_stage_reset_in;
		stage_select <= stage_select_in;
		second_stage_reset <= second_stage_reset_in;
		final_stage_reset <= final_stage_reset_in;
		dead_stage_reset <= dead_stage_reset_in;
		if(SW[2])
		begin
			state <= cover1;
			record <= 2'd0;
			BGM <= 2'd0;
			first_stage_reset <= 1'b0;
			stage_select <= 4'd0;
			second_stage_reset <= 1'b0;
			final_stage_reset <= 1'b0;
			dead_stage_reset <= 1'b1;
		end
	end
	
	always_comb
	begin
		next_state = state;
		case(state)
			cover1:
				if(confirmed)
				begin	
					if(selected_stage == 4'd1)
						next_state = reset_first;
					else if(selected_stage == 4'd2)
					begin
						if(record == 2'd1)
							next_state = reset_first;
						else if(record == 2'd2)
							next_state = reset_second;
					end
					else if(selected_stage == 4'd3)
						next_state = professor;
				end
			reset_first:
				next_state = first;
			first:
		   begin
				if(death == 1'b1)
					next_state = dead;
				else if(reach_final)
					next_state = reset_second; 
				else if(Esc|SW[15])
					next_state = cover1;
			end
			reset_second:
				next_state = second;
			second:
			begin
				if(death == 1'b1)
					next_state = dead;
				else if(victory == 1'b1)
					next_state = final_report;
				else if(Esc|SW[15])
					next_state = cover1;
			end
			dead:
			begin
				if(SW[0] == 1'b1 | R)
				begin
					if(record == 2'd1)
						next_state = reset_first;
					else if(record == 2'd2)
						next_state = reset_second;
					else 
						next_state = cover1;
				end
			end
			final_report:
			begin
				if(finish_game == 1'b1)
					next_state = cover1;
			end
			professor:
			begin
				if(SW[0] == 1'b1 | R)
					next_state = cover1;
			end
		endcase
		
		BGM_in = BGM;
		record_in = record;
		first_stage_reset_in = 1'b0;
		second_stage_reset_in = 1'b0;
		final_stage_reset_in = 1'b0;
		dead_stage_reset_in = 1'b0;
		stage_select_in = stage_select;
		case(state)
			cover1:
			begin
				BGM_in = 2'd0;	
				stage_select_in = 4'd0;
				first_stage_reset_in = 1'b1;
				second_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				if(selected_stage == 4'd1)
					dead_stage_reset_in = 1'b1;
			end
			reset_first: 
			begin
				first_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				second_stage_reset_in = 1'b1;
				stage_select_in = 4'd1;
				
			end
			first:
			begin
				BGM_in = 2'd1;
				second_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				if(death == 1'b1)
					stage_select_in = 4'd3;
				if(saved_1 == 1'b1)
					record_in = 2'd1;
			end
			second:
			begin
				BGM_in = 2'd2;
				first_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				if(death == 1'b1)
					stage_select_in = 4'd3;
				if(saved_2 == 1'b1)
					record_in = 2'd2;
			end
			reset_second:
			begin
				second_stage_reset_in = 1'b1;
				first_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				stage_select_in = 4'd2;
			end
			dead:
			begin
				BGM_in = 2'd3;
				first_stage_reset_in = 1'b1;
				second_stage_reset_in = 1'b1;
				final_stage_reset_in = 1'b1;
				if(SW[0] == 1'b1 | R)
				begin
					if(record == 2'd1)
						stage_select_in = 4'd1;
					else if(record == 2'd2)
						stage_select_in = 4'd2;
					else
						stage_select_in = 4'd0;
				end
			end
			final_report:
			begin
				first_stage_reset_in = 1'b1;
				second_stage_reset_in = 1'b1;
				stage_select_in = 4'd4;
				BGM_in = 2'd0;
			end
			professor: 
				stage_select_in = 4'd5;
		endcase
		
		
		
	end
endmodule
