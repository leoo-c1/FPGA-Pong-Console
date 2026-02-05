module startup_text #(
    parameter KERNING = 4,
    parameter TITLE_SCALE = 6,
    parameter START_SCALE = 4,
    // Coordinates for top left of the 'P' in 'PONG' so the word is centered
    parameter TITLE_X = 320 - 1.5*KERNING - 12*TITLE_SCALE,
    parameter TITLE_Y = 99,
    // Coordinates for top left of the 'P' in 'Press any key to start'
    parameter START_X = TITLE_X - 72*START_SCALE - 8*KERNING,
    parameter START_Y = TITLE_Y - 8 - 4 + 1

) (
    input clk_0,
    input rst,
    input [9:0] pixel_x, pixel_y,
    
    output reg in_text
    );

    wire in_title;
    wire in_start;

    // Generate string 'PONG'
    string_display #(
        .SCALE(8),
        .KERNING(4),
        .LEN(4),
        .TEXT("PONG")
    ) title (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(TITLE_X), .y_pos(TITLE_Y),
        .pixel_on(in_title)
    );

    // Generate string 'Press any key to start'
    string_display #(
        .SCALE(6),
        .KERNING(4),
        .LEN(22),
        .TEXT("Press any key to start")
    ) title (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(START_X), .y_pos(START_Y),
        .pixel_on(in_start)
    );

endmodule