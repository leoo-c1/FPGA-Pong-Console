module score_display (
    input clk_0,            // 25.175MHz pixel clock
    input rst,              // Reset button

    input [9:0] pixel_x,    // Current horizontal pixel
    input [9:0] pixel_y,    // Current vertical row
    
    input [9:0] x_pos,      // x-coordinate of the top left corner of the number
    input [9:0] y_pos,      // y-coordinate of the top left corner of the number
    input [3:0] number,     // The digit to draw (0-9)
    
    output reg pixel_on = 1'b0;     // 1 if the current pixel is part of the number
    );

    parameter WIDTH = 4;        // Width of the bitmap
    parameter HEIGHT = 6;       // Height of the bitmap
    parameter SCALE = 8;        // Scaling factor (maps to 32x48)

    // Position of the pixel relative to our number's origin
    wire [9:0] rel_x = pixel_x - x_pos;
    wire [9:0] rel_y = pixel_y - y_pos;

    // The corresponding row and column of our unscaled bitmap
    wire [WIDTH-1:0] rom_col = rel_x / SCALE;     
    wire [WIDTH-1:0] rom_row = rel_y / SCALE;

    // The bitmap's bits for the row we are on
    reg [WIDTH-1:0] active_row_bits;

    always @ (*) begin
        active_row_bits = 0;

        if (pixel_x >= x_pos && pixel_x <= x_pos + WIDTH*SCALE - 1) begin
            if (pixel_y >= y_pos && pixel_y <= y_pos + HEIGHT*SCALE - 1) begin
                case (number)
                    0: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b1001;
                            2: active_row_bits = 4'b1001;
                            3: active_row_bits = 4'b1001;
                            4: active_row_bits = 4'b1001;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    1: begin
                        case (rom_row)
                            0: active_row_bits = 4'b0001;
                            1: active_row_bits = 4'b0001;
                            2: active_row_bits = 4'b0001;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b0001;
                        endcase
                    end
                    2: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b0001;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b1000;
                            4: active_row_bits = 4'b1000;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    3: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b0001;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    4: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1001;
                            1: active_row_bits = 4'b1001;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b0001;
                        endcase
                    end
                    5: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b1000;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    6: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b1000;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b1001;
                            4: active_row_bits = 4'b1001;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    7: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b0001;
                            2: active_row_bits = 4'b0001;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b0001;
                        endcase
                    end
                    8: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b1001;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b1001;
                            4: active_row_bits = 4'b1001;
                            5: active_row_bits = 4'b1111;
                        endcase
                    end
                    9: begin
                        case (rom_row)
                            0: active_row_bits = 4'b1111;
                            1: active_row_bits = 4'b1001;
                            2: active_row_bits = 4'b1111;
                            3: active_row_bits = 4'b0001;
                            4: active_row_bits = 4'b0001;
                            5: active_row_bits = 4'b0001;
                        endcase
                    end
                    default: begin
                        case (rom_row)
                            0: active_row_bits = 4'b0000;
                            1: active_row_bits = 4'b0000;
                            2: active_row_bits = 4'b0000;
                            3: active_row_bits = 4'b0000;
                            4: active_row_bits = 4'b0000;
                            5: active_row_bits = 4'b0000;
                        endcase
                    end
                endcase
            end
        end
    end

    always @ (posedge clk_0) begin
        if (!rst) begin
            pixel_on <= 1'b0;

        // Check if we are on an active pixel
        end else if (active_row_bits[WIDTH - 1 - rom_col]) begin
            pixel_on <= 1'b1;
        end else begin
            pixel_on <= 1'b0;
        end
    end

endmodule