from PIL import Image
import numpy as np

#  INPUTS 
# input_image = "C:/Users/268233/Desktop/download (17).jpg"   # Input image file
input_image = "C:\\Users\\268233\\Desktop\\5th sem\\reconstructed.png"
width = 768                 # width
height = 512                #  height
output_hex = "RGB.hex"      # Output hex file name

#OPEN AND RESIZE IMAGE 
img = Image.open(input_image).convert("RGB")
img = img.resize((width, height))
img.show()
#  CONVERT TO NUMPY ARRAY 
pixels = np.array(img)  # shape = (height, width, 3)

#  FLATTEN IN RGB ORDER
flat_pixels = pixels.reshape(-1, 3)  # each row = [R, G, B]

#  STEP 4: WRITE TO SINGLE HEX FILE 
with open(output_hex, "w") as f:
    for pixel in flat_pixels:
        for value in pixel:  # R, G, B
            f.write(f"{value:02X}\n".lower())

print(f"Hex file '{output_hex}' created successfully!")
print(f"Image size: {width}x{height} , Total lines: {width * height * 3}")
