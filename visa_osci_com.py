import time
import pyvisa
from PIL import Image

# Initialize connection to the instrument
rm = pyvisa.ResourceManager()
oscilloscope = rm.open_resource('USB0::0x1AB1::0x04B0::DS2D163952005::INSTR')

# 60s waiting time
oscilloscope.timeout = 4000

# set up channel and trigger
oscilloscope.write(':CHAN1:SCALe 0.2')
oscilloscope.write('CHANnel1:OFFSet 0')
oscilloscope.write(':TRIGger:EDGE:SOURce CHANnel1')
oscilloscope.write(':TRIGger:EDGE:LEVel 0.2')
oscilloscope.write(':SINGle')
while True:
    status = oscilloscope.query(':TRIGger:STATus?').strip()
    if status == 'STOP' or status == 'TD':
        print("Stopped!")
        break

time.sleep(2)
# Set the data encoding format to BMP
oscilloscope.write(':DISPlay:DATA:FORMat BMP')

oscilloscope.write(':DISPlay:DATA?')

# Read the raw binary data
bmp_data = oscilloscope.read_raw()

# Convert the binary data to an image and display it
image = Image.frombuffer('RGB', (800, 480), bmp_data, 'raw', 'BGR', 0, -1)
image.show()