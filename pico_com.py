#
# Copyright (C) 2018-2022 Pico Technology Ltd. See LICENSE file for terms.
#
# PS5000A BLOCK MODE EXAMPLE
# This example opens a 5000a driver device, sets up two channels and a trigger then collects a block of data.
# This data is then plotted as mV against time in ns.

import ctypes
from picosdk.ps5000a import ps5000a as ps
from picosdk.functions import adc2mV, assert_pico_ok, mV2adc
import msvcrt

import measure_delay
import catch_trigger

def read_input():
    if msvcrt.kbhit():
        return msvcrt.getch().decode('utf-8')
    else:
        return None
    
# Create chandle and status ready for use
chandle = ctypes.c_int16()
status = {}

resolution = ps.PS5000A_DEVICE_RESOLUTION["PS5000A_DR_8BIT"]
status["openunit"] = ps.ps5000aOpenUnit(ctypes.byref(chandle), None, resolution)

try:
    assert_pico_ok(status["openunit"])
except: 
    powerStatus = status["openunit"]
    if powerStatus == 286:
        status["changePowerSource"] = ps.ps5000aChangePowerSource(chandle, powerStatus)
    elif powerStatus == 282:
        status["changePowerSource"] = ps.ps5000aChangePowerSource(chandle, powerStatus)
    else:
        raise
    assert_pico_ok(status["changePowerSource"])

while(True):
    cmd = input("Please enter   'd' for delay measurement mode\n"
                "               't' for trigger mode\n"
                "               'q' for quit\n\n"
                "   Your choice: ")
    print("\n")
    if cmd == 'd':
        print("Delay measurement between two signals started. Press any key to break!")
        while(True):    
            measure_delay.measure_delay_mode(chandle, status)
            if (read_input() is not None):
                print("Delay measurement stopped.")
                break
    elif cmd == 't':
        catch_trigger.catch_trigger(chandle, status)
        print("Trigger cathced!")
    elif cmd == 'q':
        print("End of program!")
        break
    else:
        print("Unknown option. Try again...")

status["stop"] = ps.ps5000aStop(chandle)
assert_pico_ok(status["stop"])
status["close"]=ps.ps5000aCloseUnit(chandle)
assert_pico_ok(status["close"])
#print(status)


