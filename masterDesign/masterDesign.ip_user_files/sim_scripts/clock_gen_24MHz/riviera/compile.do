vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" \
"C:/vivado_tool/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"C:/vivado_tool/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../masterDesign.gen/sources_1/ip/clock_gen_24MHz/clock_gen_24MHz_clk_wiz.v" \
"../../../../masterDesign.gen/sources_1/ip/clock_gen_24MHz/clock_gen_24MHz.v" \

vlog -work xil_defaultlib \
"glbl.v"

