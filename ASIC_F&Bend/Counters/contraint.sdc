create_clock -name clk -period 20 [get_ports clk] 
set_input_delay 16 -clock [get_clocks clk] [all_inputs] 
set_output_delay 2 -clock [get_clocks clk] [all_outputs] 
