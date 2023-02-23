onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+clock_gen_24MHz  -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.clock_gen_24MHz xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {clock_gen_24MHz.udo}

run 1000ns

endsim

quit -force
