module startup_text #(
    parameter KERNING = 0,
    parameter TITLE_SCALE = 10,
    parameter SELECT_SCALE = 5,
    parameter MODE_SCALE = 3,
    // Coordinates for top left of the 'P' in 'PONG' so the word is centered
    parameter TITLE_X = 320 - 3*KERNING/2 - 12*TITLE_SCALE,
    parameter TITLE_Y = 60,
    // Coordinates for top left of the 'S' in 'SELECT MODE:'
    parameter SELECT_X = 320 - 6*6*SELECT_SCALE - 5*KERNING,
    parameter SELECT_Y = TITLE_Y + 8*TITLE_SCALE + 60 - 1,
    // Coordinates for top left of the '1' in '1 PLAYER'
    parameter SP_X = 320 - 4*6*MODE_SCALE - 3*KERNING,
    parameter SP_Y = SELECT_Y + 8*SELECT_SCALE + 20 - 1,
    // Coordinates for top left of the '2' in '2 PLAYERS'
    parameter MP_X = 320 - 27*MODE_SCALE - 4*KERNING,
    parameter MP_Y = SP_Y + 8*MODE_SCALE + 20 - 1
) (
    input clk_0,
    input rst,
    
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    
    output reg in_text
    );

    wire in_title;
    wire in_select;
    wire in_sp;
    wire in_mp;

    // Generate string 'PONG'
    string_display #(
        .SCALE(TITLE_SCALE),
        .KERNING(KERNING),
        .LEN(4),
        .TEXT("PONG")
    ) title (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(TITLE_X), .y_pos(TITLE_Y),
        .pixel_on(in_title)
    );

    // Generate string 'SELECT MODE'
    string_display #(
        .SCALE(SELECT_SCALE),
        .KERNING(KERNING),
        .LEN(12),
        .TEXT("SELECT MODE:")
    ) select (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(SELECT_X), .y_pos(SELECT_Y),
        .pixel_on(in_select)
    );

    // Generate string '1 PLAYER'
    string_display #(
        .SCALE(MODE_SCALE),
        .KERNING(KERNING),
        .LEN(8),
        .TEXT("1 PLAYER")
    ) singleplayer (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(SP_X), .y_pos(SP_Y),
        .pixel_on(in_sp)
    );

    // Generate string '2 PLAYERS'
    string_display #(
        .SCALE(MODE_SCALE),
        .KERNING(KERNING),
        .LEN(9),
        .TEXT("2 PLAYERS")
    ) multiplayer (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(MP_X), .y_pos(MP_Y),
        .pixel_on(in_mp)
    );

    always @ (posedge clk_0) begin
        in_text <= (in_title | in_select | in_sp | in_mp);
    end

endmodule