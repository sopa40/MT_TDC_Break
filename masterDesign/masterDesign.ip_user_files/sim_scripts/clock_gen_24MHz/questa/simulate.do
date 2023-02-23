onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib clock_gen_24MHz_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {clock_gen_24MHz.udo}

run 1000ns

quit -force
