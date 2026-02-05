from PIL import Image, ImageDraw, ImageFont

# Setup
FONT_SIZE = 8 
OUTPUT_FILE = "font_rom.v"

def generate_verilog():
    # Try to grab a ttf, otherwise fall back to PIL default
    try:
        font = ImageFont.truetype("arial.ttf", 10) 
    except:
        font = ImageFont.load_default()

    with open(OUTPUT_FILE, "w") as f:
        # Start the module
        f.write(f"module font_rom (\n")
        f.write(f"    input [6:0] char_code,  // ascii input\n")
        f.write(f"    input [2:0] row,        // 0-7 row index\n")
        f.write(f"    output reg [7:0] row_bits // 8-bit row map\n")
        f.write(f");\n\n")
        f.write(f"    always @(*) begin\n")
        f.write(f"        case (char_code)\n")

        # Loop through standard printable ASCII
        for ascii_val in range(32, 127):
            char = chr(ascii_val)
            
            # Make a blank 8x8 canvas
            img = Image.new('1', (8, 8), color=0)
            d = ImageDraw.Draw(img)
            
            # Render the char. -2 offset to center
            d.text((0, -2), char, font=font, fill=1)
            
            f.write(f"            7'd{ascii_val}: begin // '{char}'\n")
            f.write(f"                case (row)\n")
            
            # Scan pixels to build the bitstring
            for y in range(8):
                bits = ""
                for x in range(8):
                    # Check if pixel is on
                    p = img.getpixel((x, y))
                    bits += "1" if p else "0"
                
                f.write(f"                    3'd{y}: row_bits = 8'b{bits};\n")
            
            f.write(f"                    default: row_bits = 8'b00000000;\n")
            f.write(f"                endcase\n")
            f.write(f"            end\n")

        # Clean up and close module
        f.write(f"            default: row_bits = 8'b00000000;\n")
        f.write(f"        endcase\n")
        f.write(f"    end\n")
        f.write(f"endmodule\n")

    print(f"Generated {OUTPUT_FILE}")

if __name__ == "__main__":
    generate_verilog()