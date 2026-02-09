module paddle_control #(
    parameter V_VIDEO = 480,
    parameter PDL_HEIGHT = 96,
    parameter START_X = 24,
    parameter PDL_SPEED = 600,
    parameter AI_SPEED = 500,
    parameter AI_RESET_SPEED = 300,     // Paddle vertical velocity moving back to centre post-hit
    parameter AI_REACTION_TIME = 700,
    parameter RETURN_DELAY = 400,       // Time (ms) passed before AI returns to centre
    parameter MIN_OFFSET = 0,           // Minimum error in pixels (Sharpest aim)
    parameter MAX_OFFSET = 48,          // Maximum error in pixels (Sloppiest aim)
    parameter BASE_OFFSET = 6,          // Default error when scores are tied
    parameter SCALING_FACTOR = 3        // How many pixels the error changes per point difference
)(
    input clk_0,                // 25.175MHz clock
    input rst,                  // Reset button
    input reset_game,           // Resets paddle to centre on startup or game over
    input [1:0] mode_choice,    // Gamemode choice, 0 = nothing, 1 = 1 player, 2 = 2 players

    // Player input
    input move_up,              // Whether or not to move up
    input move_down,            // Whether or not to move down

    // Square state
    input wire [9:0] sq_xpos,   // x-coordinate of the square
    input wire [9:0] sq_ypos,   // y-coordinate of the square
    input wire sq_xveldir,      // Horizontal direction the square is travelling in
    input wire sq_missed,       // If the we miss the square and it hits the left/right side
    
    // Paddle position
    output [9:0] x_pos,
    output reg [9:0] y_pos,

    // Game score
    input wire [3:0] score_p1,      // Player 1's score
    input wire [3:0] score_p2       // Player 2's score (AI)
);

    assign x_pos = START_X;
    
    // Velocity Prescaler
    localparam PSC_LIMIT = 25_175_000 / PDL_SPEED;
    reg [18:0] vel_count = 0;

    // AI opponent
    wire [9:0] ai_ypos;

    ai_opponent #(
        .V_VIDEO(V_VIDEO),
        .PDL_HEIGHT(PDL_HEIGHT),
        .SPEED(AI_SPEED),
        .RESET_SPEED(AI_RESET_SPEED),
        .REACTION_TIME(AI_REACTION_TIME),
        .RETURN_DELAY(RETURN_DELAY),
        .MIN_OFFSET(MIN_OFFSET), .MAX_OFFSET(MAX_OFFSET),
        .BASE_OFFSET(BASE_OFFSET),
        .SCALING_FACTOR(SCALING_FACTOR)
    ) computer (
        .clk_0(clk_0),
        .rst(rst),
        .sq_xpos(sq_xpos), .sq_ypos(sq_ypos),
        .sq_xveldir(sq_xveldir),
        .sq_missed(sq_missed),
        .reset_game(reset_game),
        .score_p1(score_p1), .score_p2(score_p2),
        .ai_ypos(ai_ypos)
    );

    always @(posedge clk_0 or negedge rst) begin
        if (!rst) begin
            y_pos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else if (reset_game) begin
            y_pos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else begin

            // AI mode (singleplayer)
            if (mode_choice == 2'b01) begin
                y_pos <= ai_ypos;

            // 2 player mode
            end else if (mode_choice == 2'b10) begin
                // Movement Logic
                if (move_up && !move_down) begin
                    if (vel_count < PSC_LIMIT) begin
                        vel_count <= vel_count + 1;
                    end else begin
                        vel_count <= 0;
                        if (y_pos > 0)
                            y_pos <= y_pos - 1;
                    end
                end else if (move_down && !move_up) begin
                    if (vel_count < PSC_LIMIT) begin
                        vel_count <= vel_count + 1;
                    end else begin
                        vel_count <= 0;
                        if (y_pos + PDL_HEIGHT < V_VIDEO - 1)
                            y_pos <= y_pos + 1;
                    end
                end else begin
                    vel_count <= 0; // Don't move if no key pressed
                end
            end
        end
    end
endmodule