import struct
import sys

for s in sys.argv[1:]:
    f = float(s)
    bits = struct.unpack('<I', struct.pack('<f', f))[0]
    print(s, bits)
