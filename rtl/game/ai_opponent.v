module ai_opponent #(
    parameter V_VIDEO = 480,        // Height of the video frame
    parameter PDL_HEIGHT = 96,      // Height of the paddle
    parameter SPEED = 600,          // Paddle vertical velocity in pixels/second
    parameter REACTION_TIME = 500   // Time (ms) the AI takes to react to the ball coming towards it
    )(
    input clk_0,                    // 25.175MHz clock
    input rst,                      // Reset button

    input wire [9:0] sq_xpos,       // x-coordinate of the square
    input wire [9:0] sq_ypos,       // y-coordinate of the square
    input wire sq_xveldir,          // Horizontal direction the square is travelling in

    input wire reset_game,          // Resets paddle to centre on startup or game over
    input wire sq_missed,           // If the we miss the square and it hits the left/right side

    output reg [9:0] ai_ypos        // AI-controlled paddle position
    );

    // Reaction delay
    parameter REACTION_PSC = REACTION_TIME * 25_175;     // 25175 is freq/1000 to account for ms
    parameter COUNT_WIDTH = $clog2(REACTION_PSC + 1);     // Width of count register
    reg [COUNT_WIDTH-1:0] reaction_count = 0;

    // Velocity
    localparam PSC_LIMIT = 25_175_000 / SPEED;
    reg [18:0] vel_count = 0;

    parameter sq_width = 16;                            // The side lengths of the square
    wire [9:0] ai_cent_y = ai_ypos + PDL_HEIGHT/2;      // Centre of AI paddle
    wire [9:0] sq_cent_y = sq_ypos + sq_width/2;        // Center of square

    always @ (posedge clk_0) begin
        if (!rst) begin
            ai_ypos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else if (reset_game) begin
            ai_ypos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
        end else begin
            // Check if the ball has started coming towards the AI
            if (sq_xveldir == 1'b1) begin
                // Wait for reaction time before moving
                if (reaction_count < REACTION_PSC) begin
                    reaction_count <= reaction_count + 1;
                end else begin
                    if (vel_count < PSC_LIMIT) begin
                    vel_count <= vel_count + 1;
                end else begin
                    vel_count <= 0;
                    // If paddle is below square, move up until it isn't
                    if (ai_cent_y > sq_cent_y) begin
                        // Only move up if AI isn't at the top of the screen
                        if (ai_ypos > 0) begin
                            ai_ypos <= ai_ypos - 1;
                        end
                    // If paddle is above square, move down until it isn't
                    end else if (ai_cent_y < sq_cent_y) begin
                        // Only move down is AI isn't at the bottom of the screen
                        if (ai_ypos < V_VIDEO - PDL_HEIGHT) begin
                            ai_ypos <= ai_ypos + 1;
                        end
                    end
                end
                end
            end else if (sq_missed || sq_xveldir == 1'b0) begin
                reaction_count <= 0;
                // Move back towards the centre
                if (vel_count < PSC_LIMIT) begin
                    vel_count <= vel_count + 1;
                end else begin
                    vel_count <= 0;
                    // If paddle is below centre, move up until it isn't
                    if (ai_cent_y > V_VIDEO/2) begin
                        ai_ypos <= ai_ypos - 1;
                    // If paddle is above square, move down until it isn't
                    end else if (ai_cent_y < V_VIDEO/2) begin
                        ai_ypos <= ai_ypos + 1;
                    end
                end
            end
        end

    end

endmodule