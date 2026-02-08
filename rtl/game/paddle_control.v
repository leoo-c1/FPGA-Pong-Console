module paddle_control #(
    parameter V_VIDEO = 480,
    parameter PDL_HEIGHT = 96,
    parameter START_X = 24,
    parameter SPEED = 600,
    parameter AI_REACTION_TIME = 0.5
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
    output reg [9:0] y_pos
);

    assign x_pos = START_X;
    
    // Velocity Prescaler
    localparam PSC_LIMIT = 25_175_000 / SPEED;
    reg [18:0] vel_count = 0;

    // AI opponent
    wire ai_ypos;

    ai_opponent #(
        .V_VIDEO(V_VIDEO),
        .PDL_HEIGHT(PDL_HEIGHT),
        .SPEED(SPEED),
        .REACTION_TIME(AI_REACTION_TIME)
    ) computer (
        .clk_0(clk_0),
        .rst(rst),
        .sq_xpos(sq_xpos), .sq_ypos(sq_ypos),
        .sq_xveldir(sq_xveldir),
        .sq_missed(sq_missed),
        .reset_game(reset_game),
        .ai_ypos(ai_ypos)
    )

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