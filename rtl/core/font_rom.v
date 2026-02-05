module font_rom (
    input [6:0] char_code,
    input [2:0] row,
    output reg [5:0] row_bits
);

    always @(*) begin
        case (char_code)
            7'd32: begin // ' '
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
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
            7'd34: begin // '"'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b010100;
                    3'd2: row_bits = 6'b010100;
                    3'd3: row_bits = 6'b010100;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd35: begin // '#'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b010100;
                    3'd2: row_bits = 6'b010100;
                    3'd3: row_bits = 6'b111110;
                    3'd4: row_bits = 6'b010100;
                    3'd5: row_bits = 6'b111110;
                    3'd6: row_bits = 6'b010100;
                    3'd7: row_bits = 6'b010100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd36: begin // '$'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b011110;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b011100;
                    3'd5: row_bits = 6'b000010;
                    3'd6: row_bits = 6'b111100;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd37: begin // '%'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b110000;
                    3'd2: row_bits = 6'b110010;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b100110;
                    3'd7: row_bits = 6'b000110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd38: begin // '&'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011000;
                    3'd2: row_bits = 6'b100100;
                    3'd3: row_bits = 6'b101000;
                    3'd4: row_bits = 6'b010000;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b011010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd39: begin // '''
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001100;
                    3'd2: row_bits = 6'b000100;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd40: begin // '('
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000100;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b010000;
                    3'd4: row_bits = 6'b010000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b000100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd41: begin // ')'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b010000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b000100;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b010000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd42: begin // '*'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b101010;
                    3'd4: row_bits = 6'b011100;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd43: begin // '+'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b111110;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd44: begin // ','
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b001100;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd45: begin // '-'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b111110;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd46: begin // '.'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b001100;
                    3'd7: row_bits = 6'b001100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd47: begin // '/'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000010;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd48: begin // '0'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100110;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b110010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd49: begin // '1'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b011000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd50: begin // '2'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b000010;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b010000;
                    3'd7: row_bits = 6'b111110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd51: begin // '3'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b000100;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b000010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd52: begin // '4'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000100;
                    3'd2: row_bits = 6'b001100;
                    3'd3: row_bits = 6'b010100;
                    3'd4: row_bits = 6'b100100;
                    3'd5: row_bits = 6'b111110;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b000100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd53: begin // '5'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b111100;
                    3'd4: row_bits = 6'b000010;
                    3'd5: row_bits = 6'b000010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd54: begin // '6'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001100;
                    3'd2: row_bits = 6'b010000;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd55: begin // '7'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b000010;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd56: begin // '8'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b011100;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd57: begin // '9'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b011110;
                    3'd5: row_bits = 6'b000010;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b011000;
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
            7'd59: begin // ';'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b001100;
                    3'd3: row_bits = 6'b001100;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b001100;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd60: begin // '<'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000010;
                    3'd2: row_bits = 6'b000100;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b010000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b000010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd61: begin // '='
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b111110;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b111110;
                    3'd6: row_bits = 6'b000000;
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
            7'd63: begin // '?'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b000010;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd64: begin // '@'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100110;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b100100;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
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
            7'd66: begin // 'B'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b111100;
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
            7'd70: begin // 'F'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b100000;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b100000;
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
            7'd72: begin // 'H'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b111110;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd73: begin // 'I'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd74: begin // 'J'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001110;
                    3'd2: row_bits = 6'b000100;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b000100;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b011000;
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
            7'd81: begin // 'Q'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b011010;
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
            7'd85: begin // 'U'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd86: begin // 'V'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b010100;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd87: begin // 'W'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b101010;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b110110;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd88: begin // 'X'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100010;
                    3'd2: row_bits = 6'b100010;
                    3'd3: row_bits = 6'b010100;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b010100;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
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
            7'd90: begin // 'Z'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b111110;
                    3'd2: row_bits = 6'b000010;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b111110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd91: begin // '['
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b010000;
                    3'd3: row_bits = 6'b010000;
                    3'd4: row_bits = 6'b010000;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b010000;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd92: begin // '\'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b010000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b000100;
                    3'd6: row_bits = 6'b000010;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd93: begin // ']'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011100;
                    3'd2: row_bits = 6'b000100;
                    3'd3: row_bits = 6'b000100;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b000100;
                    3'd6: row_bits = 6'b000100;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd94: begin // '^'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b010100;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd95: begin // '_'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd96: begin // '`'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011000;
                    3'd2: row_bits = 6'b010000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
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
            7'd98: begin // 'b'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100000;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b101100;
                    3'd4: row_bits = 6'b110010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b111100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd99: begin // 'c'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011100;
                    3'd4: row_bits = 6'b100000;
                    3'd5: row_bits = 6'b100000;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd100: begin // 'd'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000010;
                    3'd2: row_bits = 6'b000010;
                    3'd3: row_bits = 6'b011010;
                    3'd4: row_bits = 6'b100110;
                    3'd5: row_bits = 6'b100010;
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
            7'd102: begin // 'f'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001100;
                    3'd2: row_bits = 6'b010010;
                    3'd3: row_bits = 6'b010000;
                    3'd4: row_bits = 6'b111100;
                    3'd5: row_bits = 6'b010000;
                    3'd6: row_bits = 6'b010000;
                    3'd7: row_bits = 6'b010000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd103: begin // 'g'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011110;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b011110;
                    3'd6: row_bits = 6'b000010;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd104: begin // 'h'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b100000;
                    3'd2: row_bits = 6'b100000;
                    3'd3: row_bits = 6'b101100;
                    3'd4: row_bits = 6'b110010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100010;
                    3'd7: row_bits = 6'b100010;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd105: begin // 'i'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b011100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd106: begin // 'j'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000100;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b001100;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b000100;
                    3'd6: row_bits = 6'b100100;
                    3'd7: row_bits = 6'b011000;
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
            7'd108: begin // 'l'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b011100;
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
            7'd112: begin // 'p'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b111100;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b111100;
                    3'd6: row_bits = 6'b100000;
                    3'd7: row_bits = 6'b100000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd113: begin // 'q'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b011110;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b011110;
                    3'd6: row_bits = 6'b000010;
                    3'd7: row_bits = 6'b000010;
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
            7'd117: begin // 'u'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b100010;
                    3'd6: row_bits = 6'b100110;
                    3'd7: row_bits = 6'b011010;
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
            7'd119: begin // 'w'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b100010;
                    3'd5: row_bits = 6'b101010;
                    3'd6: row_bits = 6'b101010;
                    3'd7: row_bits = 6'b010100;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd120: begin // 'x'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b100010;
                    3'd4: row_bits = 6'b010100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b010100;
                    3'd7: row_bits = 6'b100010;
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
            7'd122: begin // 'z'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000000;
                    3'd2: row_bits = 6'b000000;
                    3'd3: row_bits = 6'b111110;
                    3'd4: row_bits = 6'b000100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b010000;
                    3'd7: row_bits = 6'b111110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd123: begin // '{'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b000110;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b011000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b000110;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd124: begin // '|'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b001000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b001000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd125: begin // '}'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b110000;
                    3'd2: row_bits = 6'b001000;
                    3'd3: row_bits = 6'b001000;
                    3'd4: row_bits = 6'b001100;
                    3'd5: row_bits = 6'b001000;
                    3'd6: row_bits = 6'b001000;
                    3'd7: row_bits = 6'b110000;
                    default: row_bits = 6'b000000;
                endcase
            end
            7'd126: begin // '~'
                case (row)
                    3'd0: row_bits = 6'b000000;
                    3'd1: row_bits = 6'b011010;
                    3'd2: row_bits = 6'b101100;
                    3'd3: row_bits = 6'b000000;
                    3'd4: row_bits = 6'b000000;
                    3'd5: row_bits = 6'b000000;
                    3'd6: row_bits = 6'b000000;
                    3'd7: row_bits = 6'b000000;
                    default: row_bits = 6'b000000;
                endcase
            end
            default: row_bits = 6'b000000;
        endcase
    end
endmodule
