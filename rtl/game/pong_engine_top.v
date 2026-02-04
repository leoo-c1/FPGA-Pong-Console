module pong_engine_top #(
    parameter BUTTONS = 4;  // Number of buttons to debounce
) (
    input clk,              // 50MHz clock
    input rst,              // Reset button

    input wire [BUTTONS-1:0] button     // Input user buttons

    output h_sync,          // Horizontal sync pulse
    output v_sync,          // Vertical sync pulse

    output red,             // Pixel red value (single bit, 0v or 0.7v)
    output green,           // Pixel green value (single bit, 0v or 0.7v)
    output blue             // Pixel blue value (single bit, 0v or 0.7v)
    );

    wire clk_0;             // Intermediate wire to connect 25.175MHz clock between modules

    // Display states
    wire [9:0] pixel_x;     // Horizontal pixel coordinate (from 0)
    wire [9:0] pixel_y;     // Vertical pixel coordinate (from 0)
    wire video_on;          // Whether or not we are in the active video region

    // Game states
    wire [9:0] square_xpos;
    wire [9:0] square_ypos;

    wire [9:0] paddle1_xpos;
    wire [9:0] paddle1_ypos;

    wire [9:0] paddle2_xpos;
    wire [9:0] paddle2_ypos;

    // Debounced button signals
    wire [BUTTONS-1:0] debounced_signal;

    vga_sync vga_sync_logic (
        .clk(clk),
        .rst(rst),
        .clk_0(clk_0),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on)
    );

    button_debouncer #(
        .BUTTONS(BUTTONS)
    ) user_input (
        .clk(clk),
        .rst(rst),
        .raw_signal(button),
        .debounced_signal(debounced_signal)
    );

    pong_logic game_state (
        .clk_0(clk_0),
        .rst(rst),
        .up_p1(debounced_signal[0]),
        .down_p1(debounced_signal[1]),
        .up_p2(debounced_signal[2]),
        .down_p2(debounced_signal[3]),
        .square_xpos(square_xpos),
        .square_ypos(square_ypos),
        .paddle1_xpos(paddle1_xpos),
        .paddle1_ypos(paddle1_ypos),
        .paddle2_xpos(paddle2_xpos),
        .paddle2_ypos(paddle2_ypos)
    );

    pong_renderer game_scene (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .square_xpos(square_xpos),
        .square_ypos(square_ypos),
        .paddle1_xpos(paddle1_xpos),
        .paddle1_ypos(paddle1_ypos),
        .paddle2_xpos(paddle2_xpos),
        .paddle2_ypos(paddle2_ypos),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule