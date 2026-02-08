module limited_font_rom (
    input [6:0] char_code,
    input [2:0] row,
    output reg [5:0] row_bits
);

    always @(*) begin
        case (char_code)
            7'd65: begin // 'A'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b111110;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd67: begin // 'C'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b100000;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd68: begin // 'D'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111000;
                    3'd2: row_bits = 6'b100100;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b111000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd69: begin // 'E'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b111110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd71: begin // 'G'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b100000;
                    3'd5: row_bits = 6'b101110;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd75: begin // 'K'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100100;
                    3'd3: row_bits = 6'b101000;
                    3'd4: row_bits = 6'b110000;
                    3'd5: row_bits = 6'b101000;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd76: begin // 'L'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100000;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b100000;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b111110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd77: begin // 'M'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b110110;
                    3'd3: row_bits = 6'b101010;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd78: begin // 'N'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b110010;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b100110;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd79: begin // 'O'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd80: begin // 'P'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b100000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd82: begin // 'R'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b101000;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd83: begin // 'S'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b011100;
                    3'd5: row_bits = 6'b000010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd84: begin // 'T'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd89: begin // 'Y'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b011100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd97: begin // 'a'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011100;
                    3'd4: row_bits = 6'b000010;
                    3'd5: row_bits = 6'b011110;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd101: begin // 'e'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011100;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b111110;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b011110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd107: begin // 'k'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100000;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100100;
                    3'd5: row_bits = 6'b101000;
                    3'd6: row_bits = 6'b110100;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd109: begin // 'm'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b110100;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd110: begin // 'n'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b101100;
                    3'd4: row_bits = 6'b110010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd111: begin // 'o'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011100;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd114: begin // 'r'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b101100;
                    3'd4: row_bits = 6'b110010;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b100000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd115: begin // 's'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011110;
                    3'd4: row_bits = 6'b100000;
                    3'd5: row_bits = 6'b011100;
                    3'd6: row_bits = 6'b000010;
                    3'd7: row_bits = 6'b111100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd116: begin // 't'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b010000;
                    3'd2: row_bits = 6'b010000;
                    3'd3: row_bits = 6'b111100;
                    3'd4: row_bits = 6'b010000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b010010;
                    3'd7: row_bits = 6'b001100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd118: begin // 'v'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b010100;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd121: begin // 'y'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b011110;
                    3'd6: row_bits = 6'b000010;
                    3'd7: row_bits = 6'b111100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd58: begin // ':'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b001100;
                    3'd3: row_bits = 6'b001100;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b001100;
                    3'd6: row_bits = 6'b001100;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd62: begin // '>'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100000;
                    3'd2: row_bits = 6'b010000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b010000;
                    3'd7: row_bits = 6'b100000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd33: begin // '!'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            default: row_bits = 6'b000000;
        endcase
    end
endmodule
