`define UART_START  2'b00
`define UART_DATA   2'b01
`define UART_STOP   2'b10
`define UART_IDLE   2'b11

`define SYSTEM_CLOCK    12000000

`define BAUD_RATE       9600   
`define UART_FULL_ETU   (`SYSTEM_CLOCK/`BAUD_RATE)
`define UART_HALF_ETU   ((`SYSTEM_CLOCK/`BAUD_RATE)/2)
