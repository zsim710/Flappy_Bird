import sys
import os
from PIL import Image

header = """
-- MADE BY T. Dendale
-- WIDTH =  16
-- HEIGHT =  16

DEPTH =  """

header_2 = """;
WIDTH = 12;
ADDRESS_RADIX = HEX;
DATA_RADIX = HEX;
CONTENT
BEGIN\n"""

if len(sys.argv) > 2:
    input_filename = sys.argv[1]
    output_filename = sys.argv[2]

    # Open the input image file
    im = Image.open(input_filename)

    # Resize image to 16x16
    im = im.resize((16, 16))

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_filename), exist_ok=True)

    # Open the output file for writing
    with open(output_filename, 'w') as f:
        print("> Image size: ")
        print(im.size)
        print("")
        w = im.size[0]
        h = im.size[1]

        print("> Writing to file: " + output_filename)

        # Write headers to the output file
        f.write(header)
        f.write(str(w * h))
        f.write(header_2)

        index = 0

        for y in range(h):  # row major order
            for x in range(w):
                r = (im.getpixel((x, y))[0] >> 4) & 0xF  # 4 bits
                g = (im.getpixel((x, y))[1] >> 4) & 0xF  # 4 bits
                b = (im.getpixel((x, y))[2] >> 4) & 0xF  # 4 bits

                total = (r << 8) | (g << 4) | b  # 12-bit value

                hexa = hex(total)[2:].zfill(3)  # Ensure 3 hex digits

                f.write(f"{index:04X} : {hexa};\n")  # 4 hex digits for address, 3 hex digits for data

                index += 1

        f.write("END;\n")

    print(">>> DONE")

else:
    print("NEED MOAR INFO")
    print("Usage: python png2mif.py <input_image_path> <output_file_path>")
