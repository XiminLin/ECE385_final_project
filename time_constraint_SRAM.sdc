#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {main_clk_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {PLL|sd1|pll7|clk[0]} -source [get_pins {PLL|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase 0 -master_clock {main_clk_50} [get_pins {PLL|sd1|pll7|clk[0]}] 
create_generated_clock -name {PLL|sd1|pll7|clk[1]} -source [get_pins {PLL|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -phase 0 -master_clock {main_clk_50} [get_pins {PLL|sd1|pll7|clk[1]}] 


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set aclr_counter 0
set clrn_counter 0
set aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|aclr]
set clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn]
set aclr_counter [get_collection_size $aclr_collection]
set clrn_counter [get_collection_size $clrn_collection]

if {$aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|aclr]
}

if {$clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn]
}
