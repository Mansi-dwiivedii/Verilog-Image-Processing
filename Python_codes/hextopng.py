import numpy as np
from PIL import Image

#  USER INPUTS 
width = 768   # width of the image
height = 512  # height of the image
# 756 528
# File names for R, G, B channels
r_file = 'R_dump.hex'
g_file = 'G_dump.hex'
b_file = 'B_dump.hex'

# FUNCTION TO READ HEX VALUES (one per line) 
def read_hex_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
        a = 0
        print(type(lines[len(lines)-1]))
        for i in range(len(lines)) :
            # print(line)
            if lines[i].strip() == "xx":
                a+= 1
                lines[i] = "ff"
        print(a)
        # Strip newline and convert hex to int
        return np.array([int(line.strip(), 16) for line in lines if line.strip()], dtype=np.uint8)

#  READ EACH CHANNEL 
R = read_hex_file(r_file)
G = read_hex_file(g_file)
B = read_hex_file(b_file)

#  VALIDATION 
if not (len(R) == len(G) == len(B)):
    raise ValueError(" The hex files must have the same number of pixel values!")

# RESHAPE INTO 2D IMAGES 
R = R.reshape((height, width))
G = G.reshape((height, width))
B = B.reshape((height, width))

#  STACK INTO 3D IMAGE 
image = np.dstack((R, G, B))  # Combine as RGB

#  SAVE AS PNG 
img = Image.fromarray(image, 'RGB')
img.save('output_image.png')

print("✅ Image successfully created and saved as 'output_image.png'")
