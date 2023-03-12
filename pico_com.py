#
# Copyright (C) 2018-2022 Pico Technology Ltd. See LICENSE file for terms.
#
# PS5000A BLOCK MODE EXAMPLE
# This example opens a 5000a driver device, sets up two channels and a trigger then collects a block of data.
# This data is then plotted as mV against time in ns.

import ctypes
import numpy as np
from picosdk.ps5000a import ps5000a as ps
import matplotlib.pyplot as plt
from picosdk.functions import adc2mV, assert_pico_ok, mV2adc
import msvcrt

import measure_delay

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

cmd = input("Please enter 'd' for delay measurement and 't' for trigger: ")
if cmd == 'd':
    print("Delay measurement between two signals started. Press any key to break!")
    while(True):    
        measure_delay.measure_delay_mode(chandle, status)
        if (read_input() is not None):
            print("Delay measurement stopped.")
            break

#time = np.linspace(0, (cmaxSamples.value - 1) * timeIntervalns.value, cmaxSamples.value)
# plot data from channel A and B
# plt.plot(time, adc2mVChAMax[:])
# plt.plot(time, adc2mVChBMax[:])
# plt.xlabel('Time (ns)')
# plt.ylabel('Voltage (mV)')
# plt.show()

status["stop"] = ps.ps5000aStop(chandle)
assert_pico_ok(status["stop"])
status["close"]=ps.ps5000aCloseUnit(chandle)
assert_pico_ok(status["close"])
#print(status)


