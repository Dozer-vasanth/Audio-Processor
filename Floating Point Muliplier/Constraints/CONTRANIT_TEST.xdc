set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports done]
set_property IOSTANDARD LVCMOS18 [get_ports enable]
set_property IOSTANDARD LVCMOS18 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports rx]
set_property IOSTANDARD LVCMOS18 [get_ports status]
set_property PACKAGE_PIN E3 [get_ports clk]
set_property PACKAGE_PIN N14 [get_ports done]
set_property PACKAGE_PIN J15 [get_ports enable]
set_property PACKAGE_PIN L16 [get_ports reset]
set_property PACKAGE_PIN R10 [get_ports rx]
set_property PACKAGE_PIN V17 [get_ports status]

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

