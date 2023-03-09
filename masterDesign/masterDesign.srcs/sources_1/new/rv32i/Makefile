ROMS					= ROMS/bin ROMS/hex
ROM_FILES 				= $(ROMS:=.mem)

HEADERS					= common
HEADER_FILES			= $(HEADERS:=.svh)

SOURCES					= alu comparator register register_file data_mem instruction_mem decoder_b decoder_i decoder_j decoder_r decoder_s decoder_u program_counter_incrementer program_counter controlpath datapath core
SOURCE_FILES 			= $(SOURCES:=.sv)
TEST_FILES				= $(addprefix TB/,$(addsuffix _tb.vcd,$(SOURCES)))

TARGET 					= TB/core_tb

VERILOG_CC 				= iverilog
VERILOG_CC_FLAGS 		= -Wall -g2012
VERILOG_SIM				= vvp
VERILOG_SIM_FLAGS 		=

$(TARGET).out: $(ROM_FILES) $(HEADER_FILES) $(SOURCE_FILES)
	$(VERILOG_CC) $(VERILOG_CC_FLAGS) -o $(TARGET).out $(HEADER_FILES) $(SOURCE_FILES) $(TARGET).sv
	$(VERILOG_SIM) $(VERILOG_SIM_FLAGS) $(TARGET).out
	
test: clean $(TEST_FILES)

%.vcd: %.sv
	$(VERILOG_CC) -o SIM/a.out $(VERILOG_CC_FLAGS) $(HEADER_FILES) $(SOURCE_FILES) $<
	$(VERILOG_SIM) $(VERILOG_SIM_FLAGS) ./SIM/a.out
	mv *.vcd ./SIM/

.PHONY: clean
clean:
	@echo 
	rm -rf $(TARGET).out
	rm -rf a.out
	rm -rf ./*.vcd
	rm -rf *.json
	rm -rf SIM/*.vcd
	rm -rf SIM/*.out

yosys: $(HEADER_FILES) $(SOURCE_FILES)
	yosys \
		-p "read_verilog -sv $(HEADER_FILES)" 	\
		-p "read_verilog -sv $(SOURCE_FILES)" 	\
		-p "hierarchy -check"					\
		-p "proc"								\
		-p "opt"								\
		-p "fsm"								\
		-p "opt"								\
		-p "show PROGRAM_COUNTER"

print-%  : ; @echo $* = $($*)