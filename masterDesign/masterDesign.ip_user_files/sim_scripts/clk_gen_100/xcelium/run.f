-makelib xcelium_lib/xpm -sv \
  "C:/vivado_tool/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/vivado_tool/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../masterDesign.gen/sources_1/ip/clk_gen_100/clk_gen_100_clk_wiz.v" \
  "../../../../masterDesign.gen/sources_1/ip/clk_gen_100/clk_gen_100.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib
