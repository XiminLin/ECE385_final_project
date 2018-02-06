//this is the top level for keyboard reading
//we will only use SoC for keyboard control
//this will also include the SDRAM controller
//remeber to connect this to SDRAM interface later
module keyboard(
	input CLOCK_50,
	//the output display is for test use
	input        [3:0]  KEY,          //bit 0 is set up as Reset
	//for test
	output logic [6:0] HEX0, HEX1,
	inout wire [15:0] OTG_DATA,
	output logic [1:0] OTG_ADDR,
	output logic OTG_CS_N,
					 OTG_RD_N,
					 OTG_WR_N,
					 OTG_RST_N
);


	logic Clk, Reset_h;
	logic [15:0] keycode;

	logic [1:0] hpi_addr;
	logic [15:0] hpi_data_in, hpi_data_out;
	logic hpi_r, hpi_w, hpi_cs;
	assign Clk = CLOCK_50;
	always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
   end

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );
	 
     keyboard_SOC nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
endmodule
