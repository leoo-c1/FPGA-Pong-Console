module pong_renderer (
    input clk_0,            // 25.175MHz clock
    input rst,              // Reset button

    input [9:0] pixel_x,    // Horizontal position of pixel
    input [9:0] pixel_y,    // Vertical position of pixel
    input video_on,         // Whether or not we are in the active video region

    // Coordinates for the top left corner of each sprite
    input wire [9:0] square_xpos,
    input wire [9:0] square_ypos,

    input wire [9:0] paddle1_xpos,
    input wire [9:0] paddle1_ypos,

    input wire [9:0] paddle2_xpos,
    input wire [9:0] paddle2_ypos,

    // Game states
    input wire sq_shown,    // Whether the square should be shown or not

    input wire [3:0] score_p1,  // Player 1's score
    input wire [3:0] score_p2,  // Player 2's score
    input wire game_over,       // Whether or not the game is over
    input wire game_startup,    // Whether or not we are on the startup menu

    output reg red,         // Red colour (either 0v or 0.7v)
    output reg green,       // Green colour (either 0v or 0.7v)
    output reg blue         // Blue colour (either 0v or 0.7v)
    );

    parameter h_video = 640;        // Horizontal active video (in pixels)
    parameter v_video = 480;        // Vertical active video (in lines)

    parameter square_width = 16;    // The side lengths of the square
    parameter paddle_width = 12;    // The thickness of the paddle
    parameter paddle_height = 96;   // The height of the paddle
    parameter net_width = 12;       // The side lengths of the net squares

    reg [4:0] net_counter = 0;

    reg in_square = 1'b0;           // If current pixel is inside the square
    wire in_square_raw;
    reg in_paddle1 = 1'b0;          // If current pixel is inside paddle1
    wire in_paddle1_raw;
    reg in_paddle2 = 1'b0;          // If current pixel is inside paddle2
    wire in_paddle2_raw;
    reg in_net = 1'b0;              // If current pixel is inside the net
    wire in_scoreboard;             // If the current pixel is in the scoreboard
    wire in_startup_text;           // If the current pixel is in the startup text ('PONG...')
    wire in_over_text;              // If the current pixel is in the game over text

    // Startup text
    startup_text startup_menu (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .in_text(in_startup_text)
    );

    // Game over text
    game_over game_over_text (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .in_text(in_over_text)
    );

    // Scoreboard
    scoreboard_renderer scoreboard (
        .clk(clk_0),
        .rst(rst),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .score_p1(score_p1),
        .score_p2(score_p2),
        .pixel_on(in_scoreboard)
    );

    // Detect square
    rect_renderer #(.WIDTH(square_width), .HEIGHT(square_width)) draw_sq (
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .rect_x(square_xpos), .rect_y(square_ypos),
        .is_active(in_square_raw)
    );
    
    // Detect paddle 1
    rect_renderer #(.WIDTH(paddle_width), .HEIGHT(paddle_height)) draw_p1 (
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .rect_x(paddle1_xpos), .rect_y(paddle1_ypos),
        .is_active(in_paddle1_raw)
    );

    // Detect paddle 2
    rect_renderer #(.WIDTH(paddle_width), .HEIGHT(paddle_height)) draw_p2 (
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .rect_x(paddle2_xpos), .rect_y(paddle2_ypos),
        .is_active(in_paddle2_raw)
    );

    always @ (posedge clk_0) begin
        if (!rst) begin             // If we press the reset button, show black
            red <= 1'b0;
            green <= 1'b0;
            blue <= 1'b0;
            in_square <= 1'b0;
            in_paddle1 <= 1'b0;
            in_paddle2 <= 1'b0;
            in_net <= 1'b0;
            net_counter <= 0;

        end else if (video_on) begin    // If we are in the active video region
            // Continuously check if we are in a sprite
            in_square <= in_square_raw;
            in_paddle1 <= in_paddle1_raw;
            in_paddle2 <= in_paddle2_raw;

            if (pixel_y == 0 && pixel_x == 0) begin
                net_counter <= 18; 
            end 
            // Check for Start of New Line
            else if (pixel_x == 0) begin
                if (net_counter == 23) begin
                    net_counter <= 0;
                end else begin
                    net_counter <= net_counter + 1;
                end
            end

            if (pixel_x >= h_video/2 - net_width/2 && pixel_x <= h_video/2 + net_width/2 - 1) begin
                if (net_counter < 12) begin
                    in_net <= 1'b1;
                end
            end else begin
                in_net <= 1'b0;
            end

            

            // If we are on the startup menu
            if (game_startup) begin
                if (in_startup_text) begin
                    red <= 1'b1;
                    green <= 1'b1;
                    blue <= 1'b1;
                end else begin
                    red <= 1'b0;
                    green <= 1'b0;
                    blue <= 1'b0;
                end

            // If we are on the game over screen
            end else if (game_over) begin
                if (in_over_text) begin
                    red <= 1'b1;
                    green <= 1'b1;
                    blue <= 1'b1;
                end else begin
                    red <= 1'b0;
                    green <= 1'b0;
                    blue <= 1'b0;
                end

            // If we are inside a game sprite, make the pixel white
            end else if (in_paddle1 || in_paddle2 || (in_square && sq_shown) || 
                        in_net || in_scoreboard) begin
                red <= 1'b1;
                green <= 1'b1;
                blue <= 1'b1;
            // If we are outside of a sprite, make the pixel black
            end else begin
                red <= 1'b0;
                green <= 1'b0;
                blue <= 1'b0;
            end

        end else begin          // If we are outside the active video region, show black
            red <= 1'b0;
            green <= 1'b0;
            blue <= 1'b0;
        end

    end

endmodule