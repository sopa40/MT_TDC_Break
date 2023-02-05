import serial
import sys
import msvcrt
import time

START_CHAIN_VALUE = b's'
MIN_DELAY_UNITS = 4
MAX_DELAY_UNITS = 4000

# change com port to the corresponding one on your machine
ser = serial.Serial("com4",9600,timeout=0.25)
if ser.isOpen() == False:
    ser.open()
    
while True:
    cmd = input("Please enter 's' for start and 'q' to quit: ")
    if cmd == 's':
        while True:
            delay_len = int(input("Please enter delay length between 4 and 4000: "))
            if MIN_DELAY_UNITS <= delay_len <= MAX_DELAY_UNITS:
                break
            else:
                print("Wrong delay len entered!")
                
        ser.write(START_CHAIN_VALUE)
        time.sleep(0.1)
        converted_value = delay_len.to_bytes(2, 'little')
        print("sending..")
        print(converted_value)
        ser.write(converted_value)
        print("Configuration sent!")
        while True:
            out = ser.read()
            print("Response is: ")
            print(out)
    
    elif cmd == 'q':
        break
        
    else: 
        print("Command '" + q + "' ignored")

