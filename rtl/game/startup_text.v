module startup_text #(
    parameter KERNING = 0,
    parameter TITLE_SCALE = 8,
    parameter START_SCALE = 3,
    // Coordinates for top left of the 'P' in 'PONG' so the word is centered
    parameter TITLE_X = 320 - 3*KERNING/2 - 12*TITLE_SCALE,
    parameter TITLE_Y = 99,
    // Coordinates for top left of the 'P' in 'Press any key to start'
    parameter START_X = 320 - 66*START_SCALE - 10*KERNING,
    parameter START_Y = TITLE_Y + 8*TITLE_SCALE + 20 - 1

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

    // Generate string 'Press any key to start'
    string_display #(
        .SCALE(START_SCALE),
        .KERNING(KERNING),
        .LEN(22),
        .TEXT("Press any key to start")
    ) start (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(START_X), .y_pos(START_Y),
        .pixel_on(in_start)
    );

    always @ (posedge clk_0) begin
        in_text <= (in_title | in_start);
    end

endmodule