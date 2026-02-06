module pong_engine_top #(
    parameter BUTTONS = 4   // Number of buttons to debounce
) (
    input clk,              // 50MHz clock
    input rst,              // Reset button

    input wire [BUTTONS-1:0] button,    // Input user buttons

    output h_sync,          // Horizontal sync pulse
    output v_sync,          // Vertical sync pulse

    output red,             // Pixel red value (single bit, 0v or 0.7v)
    output green,           // Pixel green value (single bit, 0v or 0.7v)
    output blue             // Pixel blue value (single bit, 0v or 0.7v)
    );

    wire clk_0;             // Intermediate wire to connect 25.175MHz clock between modules
    wire pll_locked;

    sys_pll pll_inst (
        .inclk0(clk),       // 50MHz input clock
        .rst(1'b1),        // Reset button
        .c0(clk_0),         // 25.175MHz output clock
        .locked(pll_locked)
    );

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

    wire sq_shown;
    wire [3:0] score_p1;
    wire [3:0] score_p2;
    wire game_over;
    wire game_startup;

    // Paddle control
    wire ctrl_p1_up;
    wire ctrl_p1_down;
    wire ctrl_p2_up;
    wire ctrl_p2_down;

    vga_sync vga_sync_logic (
        .clk_0(clk_0),
        .rst(1'b1),
        .h_sync(h_sync), .v_sync(v_sync),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .video_on(video_on)
    );

    // Input bridge
    input_bridge #(.BUTTONS(BUTTONS)) input_manager (
        .clk(clk), 
        .rst(rst),
        .input_mode(2'b00), // Choose buttons for now
        .btn_raw(button),
        .p1_up(ctrl_p1_up), .p1_down(ctrl_p1_down),
        .p2_up(ctrl_p2_up), .p2_down(ctrl_p2_down)
    );

    pong_logic game_state (
        .clk_0(clk_0),
        .rst(rst),
        .up_p1(ctrl_p1_up), .down_p1(ctrl_p1_down),
        .up_p2(ctrl_p2_up), .down_p2(ctrl_p2_down),
        .sq_xpos(square_xpos), .sq_ypos(square_ypos),
        .pdl1_xpos(paddle1_xpos), .pdl1_ypos(paddle1_ypos),
        .pdl2_xpos(paddle2_xpos), .pdl2_ypos(paddle2_ypos),
        .sq_shown(sq_shown),
        .score_p1(score_p1), .score_p2(score_p2),
        .game_over(game_over),
        .game_startup(game_startup)
    );

    pong_renderer game_scene (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .video_on(video_on),
        .square_xpos(square_xpos), .square_ypos(square_ypos),
        .paddle1_xpos(paddle1_xpos), .paddle1_ypos(paddle1_ypos),
        .paddle2_xpos(paddle2_xpos), .paddle2_ypos(paddle2_ypos),
        .sq_shown(sq_shown),
        .score_p1(score_p1), .score_p2(score_p2),
        .game_over(game_over),
        .game_startup(game_startup),
        .red(red), .green(green), .blue(blue)
    );

endmodule