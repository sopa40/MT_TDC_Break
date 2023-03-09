all: main.s
	riscv64-unknown-elf-as -march=rv32i ./main.s
	riscv64-unknown-elf-objcopy \
		-O binary \
		-j .text \
		--reverse-bytes=4 \
		a.out \
		rv32i_instructions
	xxd -u -c 4 -ps rv32i_instructions


.PHONY: clean
clean:
	rm -rf a.out
	rm -rf rv32i_instructions

#riscv64-unknown-elf-objdump -d --endian=little -Mnumeric ./a.out
#objcopy -O binary -j .text f.o fo # to extract only text section