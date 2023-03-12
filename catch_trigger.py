import ctypes
import numpy as np
from picosdk.ps5000a import ps5000a as ps
import matplotlib.pyplot as plt
from picosdk.functions import adc2mV, assert_pico_ok, mV2adc

def catch_trigger(chandle, status):
    coupling_type = ps.PS5000A_COUPLING["PS5000A_DC"]
    channel = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_B"]
    chBRange = ps.PS5000A_RANGE["PS5000A_500MV"]
    status["setChB"] = ps.ps5000aSetChannel(chandle, channel, 1, coupling_type, chBRange, 0)
    assert_pico_ok(status["setChB"])

    maxADC = ctypes.c_int16()
    status["maximumValue"] = ps.ps5000aMaximumValue(chandle, ctypes.byref(maxADC))
    assert_pico_ok(status["maximumValue"])

    source = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_B"]
    threshold = int(mV2adc(200,chBRange, maxADC))
    status["trigger"] = ps.ps5000aSetSimpleTrigger(chandle, 1, source, threshold, 2, 0, 0)
    assert_pico_ok(status["trigger"])

    preTriggerSamples = 400
    postTriggerSamples = 400
    maxSamples = preTriggerSamples + postTriggerSamples
    timebase = 1
    timeIntervalns = ctypes.c_float()
    returnedMaxSamples = ctypes.c_int32()

    status["getTimebase2"] = ps.ps5000aGetTimebase2(chandle, timebase, maxSamples, ctypes.byref(timeIntervalns), ctypes.byref(returnedMaxSamples), 0)
    assert_pico_ok(status["getTimebase2"])

    status["runBlock"] = ps.ps5000aRunBlock(chandle, preTriggerSamples, postTriggerSamples, timebase, None, 0, None, None)
    assert_pico_ok(status["runBlock"])

    ready = ctypes.c_int16(0)
    check = ctypes.c_int16(0)
    while ready.value == check.value:
        status["isReady"] = ps.ps5000aIsReady(chandle, ctypes.byref(ready))

    bufferBMax = (ctypes.c_int16 * maxSamples)()
    bufferBMin = (ctypes.c_int16 * maxSamples)() 

    source = ps.PS5000A_CHANNEL["PS5000A_CHANNEL_B"]
    status["setDataBuffersB"] = ps.ps5000aSetDataBuffers(chandle, source, ctypes.byref(bufferBMax), ctypes.byref(bufferBMin), maxSamples, 0, 0)
    assert_pico_ok(status["setDataBuffersB"])

    overflow = ctypes.c_int16()
    cmaxSamples = ctypes.c_int32(maxSamples)
    status["getValues"] = ps.ps5000aGetValues(chandle, 0, ctypes.byref(cmaxSamples), 0, 0, 0, ctypes.byref(overflow))
    assert_pico_ok(status["getValues"])

    adc2mVChBMax =  adc2mV(bufferBMax, chBRange, maxADC)

    time = np.linspace(0, (cmaxSamples.value - 1) * timeIntervalns.value, cmaxSamples.value)
    plt.plot(time, adc2mVChBMax[:])
    plt.xlabel('Time (ns)')
    plt.ylabel('Voltage (mV)')
    plt.show()