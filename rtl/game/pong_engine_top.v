module pong_engine_top #(
    // Ball settings
    parameter SQ_INIT_XVEL = 300, // Used at the start of every new game and round
    parameter SQ_MIN_XVEL = 600,  // Used for paddle centre hits
    parameter SQ_MAX_XVEL = 800,  // Maximum horizontal velocity in pixels/second for edge hits

    // Control settings
    parameter PLAYER_SPEED = 500,       // Speed of the player's paddle
    parameter AI_SPEED = 500,           // Speed of the AI's paddle
    parameter AI_RESET_SPEED = 200,     // Paddle vertical velocity moving back to centre post-hit
    parameter AI_REACTION_TIME = 400,   // Time (ms) the AI takes to react to the ball coming
    parameter RETURN_DELAY = 400,       // Time (ms) passed before AI returns to centre
    parameter MIN_OFFSET = 20,          // Minimum error in pixels (Sharpest aim)
    parameter MAX_OFFSET = 50,          // Maximum error in pixels (Sloppiest aim)
    parameter BASE_OFFSET = 15,         // Default error when scores are tied
    parameter SCALING_FACTOR = 5,      // How many pixels the error changes per point difference

    // Sprite settings
    parameter SQ_WIDTH = 16,
    parameter PADDLE_HEIGHT = 48,
    parameter PADDLE_WIDTH = 12
) (
    input clk,              // 50MHz clock
    input rst,              // Reset button

    input wire [3:0] button,    // Input user buttons
    input wire uart_rx,                 // UART receive

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

    wire in_menu_text; // Pixels for the menu text
    wire [1:0] current_mode_choice;
    wire ctrl_start_trigger;

    vga_sync vga_sync_logic (
        .clk_0(clk_0),
        .rst(1'b1),
        .h_sync(h_sync), .v_sync(v_sync),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .video_on(video_on)
    );

    // Input bridge
    input_bridge input_manager (
        .clk(clk), 
        .rst(rst),
        .input_mode(2'b01), // Choose uart for now
        .btn_raw(button), .uart_rx(uart_rx),
        .p1_up(ctrl_p1_up), .p1_down(ctrl_p1_down),
        .p2_up(ctrl_p2_up), .p2_down(ctrl_p2_down),
        .start_trigger(ctrl_start_trigger)
    );

    // Start menu
    start_menu startup_menu (
        .clk_0(clk_0), .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .up(ctrl_p1_up), .down(ctrl_p1_down),
        .start_trigger(ctrl_start_trigger),
        .in_text(in_menu_text),
        .mode_choice(current_mode_choice)
    );

    pong_logic #(
        .INIT_XVEL(SQ_INIT_XVEL),
        .MIN_XVEL(SQ_MIN_XVEL),
        .MAX_XVEL(SQ_MAX_XVEL),

        .PDL_SPEED(PLAYER_SPEED),
        .AI_SPEED(AI_SPEED),
        .AI_RESET_SPEED(AI_RESET_SPEED),
        .AI_REACTION_TIME(AI_REACTION_TIME),
        .RETURN_DELAY(RETURN_DELAY),
        .MIN_OFFSET(MIN_OFFSET), .MAX_OFFSET(MAX_OFFSET),
        .BASE_OFFSET(BASE_OFFSET),
        .SCALING_FACTOR(SCALING_FACTOR),

        .SQ_WIDTH(SQ_WIDTH),
        .PDL_HEIGHT(PADDLE_HEIGHT),
        .PDL_WIDTH(PADDLE_WIDTH)
    ) game_state (
        .clk_0(clk_0),
        .rst(rst),
        .up_p1(ctrl_p1_up), .down_p1(ctrl_p1_down),
        .up_p2(ctrl_p2_up), .down_p2(ctrl_p2_down),
        .mode_choice(current_mode_choice),
        .start_trigger(ctrl_start_trigger),
        .sq_xpos(square_xpos), .sq_ypos(square_ypos),
        .pdl1_xpos(paddle1_xpos), .pdl1_ypos(paddle1_ypos),
        .pdl2_xpos(paddle2_xpos), .pdl2_ypos(paddle2_ypos),
        .sq_shown(sq_shown),
        .score_p1(score_p1), .score_p2(score_p2),
        .game_over(game_over),
        .game_startup(game_startup)
    );

    pong_renderer #(
        .SQ_WIDTH(SQ_WIDTH),
        .PDL_HEIGHT(PADDLE_HEIGHT),
        .PDL_WIDTH(PADDLE_WIDTH)
        ) game_scene (
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
        .in_startup_text(in_menu_text),
        .red(red), .green(green), .blue(blue)
    );

endmodule