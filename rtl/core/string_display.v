module string_display #(
    parameter SCALE = 4,            // Scaling factor
    parameter KERNING = 4,          // Pixel gap between characters
    parameter LEN = 4,              // Number of characters in the string
    parameter [LEN*8-1:0] TEXT = "" // The ASCII string (packed MSB first)
)(
    input wire clk_0,
    input wire rst,
    
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    
    input wire [9:0] x_pos,         // Top-left x coordinate of the string
    input wire [9:0] y_pos,         // Top-left y coordinate of the string
    
    output reg pixel_on
);

    localparam CHAR_WIDTH = 6 * SCALE;
    localparam TOTAL_CHAR_WIDTH = CHAR_WIDTH + KERNING;
    localparam STRING_HEIGHT = 8 * SCALE;
    // Total width of the entire string area
    localparam STRING_WIDTH = LEN * TOTAL_CHAR_WIDTH;

    // Relative coordinates
    wire [9:0] rel_x = pixel_x - x_pos;
    wire [9:0] rel_y = pixel_y - y_pos;

    // Check if current pixel is inside the big rectangle of the whole string
    wire in_string_box = (pixel_x >= x_pos) && (pixel_x < x_pos + STRING_WIDTH) &&
                         (pixel_y >= y_pos) && (pixel_y < y_pos + STRING_HEIGHT);

    // The character index (0 to LEN-1) we are currently scanning
    wire [9:0] char_index = rel_x / TOTAL_CHAR_WIDTH;

    // The x coordinate inside the specific character
    wire [9:0] char_rel_x = rel_x % TOTAL_CHAR_WIDTH;

    // Make sure we are not in the kerning gap
    wire in_char_body = (char_rel_x < CHAR_WIDTH);

    reg [7:0] current_char_val;

    always @(*) begin
        // If the index is valid
        if (char_index < LEN) begin
            // Extract the byte from TEXT
            current_char_val = TEXT[(LEN - 1 - char_index) * 8 +: 8];
        end else begin
            current_char_val = 8'h00; // Null/Space
        end
    end

    // Scale down the coordinates to find the ROM row/col
    wire [2:0] rom_row = rel_y / SCALE;
    wire [2:0] rom_col = char_rel_x / SCALE;
    wire [5:0] row_bits;

    // Instantiate one Font ROM for this entire string
    font_rom font_unit (
        .char_code(current_char_val[6:0]),
        .row(rom_row),
        .row_bits(row_bits)
    );

    // pixel_on control
    always @(posedge clk_0) begin
        if (!rst) pixel_on <= 0;
        else begin
            // If we are inside the string box, inside a character (not the gap), 
            // and the font ROM says "pixel on" for this bit:
            if (in_string_box && in_char_body && row_bits[5 - rom_col])
                pixel_on <= 1'b1;
            else
                pixel_on <= 1'b0;
        end
    end

endmodule