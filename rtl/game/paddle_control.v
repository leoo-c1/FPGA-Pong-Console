module paddle_control #(
    parameter V_VIDEO = 480,
    parameter PDL_HEIGHT = 96,
    parameter START_X = 24,
    parameter SPEED = 600
)(
    input clk,          // 50MHz clock
    input rst,          // Reset button
    input reset_game,   // Resets paddle to centre on startup or game over
    input move_up,      // Whether or not to move up
    input move_down,    // Whether or not to move down
    
    // Paddle position
    output [9:0] x_pos,
    output reg [9:0] y_pos
);

    assign x_pos = START_X;
    
    // Velocity Prescaler
    localparam PSC_LIMIT = 25_175_000 / SPEED;
    reg [18:0] vel_count = 0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            y_pos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else if (reset_game) begin
            y_pos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else begin
            // Movement Logic
            if (move_up && !move_down) begin
                if (vel_count < PSC_LIMIT) begin
                    vel_count <= vel_count + 1;
                end else begin
                    vel_count <= 0;
                    if (y_pos > 0) y_pos <= y_pos - 1;
                end
            end else if (move_down && !move_up) begin
                if (vel_count < PSC_LIMIT) begin
                    vel_count <= vel_count + 1;
                end else begin
                    vel_count <= 0;
                    if (y_pos + PDL_HEIGHT < V_VIDEO - 1) y_pos <= y_pos + 1;
                end
            end else begin
                vel_count <= 0; // Don't move if no key pressed
            end
        end
    end
endmodule