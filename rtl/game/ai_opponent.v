module ai_opponent #(
    parameter V_VIDEO = 480,        // Height of the video frame
    parameter PDL_HEIGHT = 96,      // Height of the paddle
    parameter SPEED = 600,          // Paddle vertical velocity in pixels/second
    parameter RESET_SPEED = 50,     // Paddle vertical velocity moving back to centre post-hit
    parameter REACTION_TIME = 500,  // Time (ms) the AI takes to react to the ball coming towards it
    parameter RETURN_DELAY = 400,   // Time (ms) passed before AI returns to centre
    
    // Difficulty Parameters
    parameter MIN_OFFSET = 0,       // Minimum error in pixels (Sharpest aim)
    parameter MAX_OFFSET = 48,      // Maximum error in pixels (Sloppiest aim)
    parameter BASE_OFFSET = 6,      // Default error when scores are tied
    parameter SCALING_FACTOR = 3    // How many pixels the error changes per point difference
    )(
    input clk_0,                    // 25.175MHz clock
    input rst,                      // Reset button

    input wire [9:0] sq_xpos,       // x-coordinate of the square
    input wire [9:0] sq_ypos,       // y-coordinate of the square
    input wire sq_xveldir,          // Horizontal direction the square is travelling in

    input wire reset_game,          // Resets paddle to centre on startup or game over
    input wire sq_missed,           // If the we miss the square and it hits the left/right side

    // Score inputs for difficulty adjustment
    input wire [3:0] score_p1,      // Player 1's score
    input wire [3:0] score_p2,      // Player 2's score (AI)

    output reg [9:0] ai_ypos        // AI-controlled paddle position
    );

    // Reaction and return delay
    parameter REACTION_PSC = REACTION_TIME * 25_175;    // 25175 is freq/1000 to account for ms
    parameter COUNT_WIDTH = $clog2(REACTION_PSC + 1);   // Width of count register
    reg [COUNT_WIDTH-1:0] reaction_count = 0;

    parameter RETURN_PSC = RETURN_DELAY * 25_175;       // 25175 is freq/1000 to account for ms
    parameter DELAY_WIDTH = $clog2(RETURN_PSC + 1);     // Width of return delay register
    reg [DELAY_WIDTH-1:0] return_count = 0;


    // Velocity
    localparam PSC_LIMIT = 25_175_000 / SPEED;
    reg [18:0] vel_count = 0;
    localparam RESET_PSC_LIMIT = 25_175_000 / RESET_SPEED;
    reg [18:0] reset_vel_count = 0;

    parameter sq_width = 16;                            // The side lengths of the square
    wire [9:0] ai_cent_y = ai_ypos + PDL_HEIGHT/2;      // Centre of AI paddle
    wire [9:0] sq_cent_y = sq_ypos + sq_width/2;        // Center of square

    // Random number generator for error calculation
    reg [5:0] lfsr_data = 6'h1F;

    always @(posedge clk_0) begin
        if (!rst)
            lfsr_data <= 6'h1F;
        else
            lfsr_data <= {lfsr_data[4:0], lfsr_data[5] ^ lfsr_data[4]};
    end

    // Dynamic Difficulty: Map score difference to offset range
    reg [9:0] difficulty_offset;
    reg [9:0] offset_delta; // Temporary variable for calculation

    always @(*) begin
        // If AI is winning (Score P2 > Score P1)
        if (score_p2 > score_p1) begin
            offset_delta = (score_p2 - score_p1) * SCALING_FACTOR;
            
            // Add delta to base, clamp to MAX_OFFSET
            if (BASE_OFFSET + offset_delta > MAX_OFFSET)
                difficulty_offset = MAX_OFFSET;
            else
                difficulty_offset = BASE_OFFSET + offset_delta;
        end
        // If Player is winning (Score P1 > Score P2)
        else if (score_p1 > score_p2) begin
            offset_delta = (score_p1 - score_p2) * SCALING_FACTOR;

            // Subtract delta from base, clamp to MIN_OFFSET
            if (offset_delta > (BASE_OFFSET - MIN_OFFSET))
                difficulty_offset = MIN_OFFSET;
            else
                difficulty_offset = BASE_OFFSET - offset_delta;
        end
        // If Tied
        else begin
            difficulty_offset = BASE_OFFSET;
        end
    end

    // Target logic
    reg [9:0] dynamic_target_y;     // Where the AI is currently trying to move to
    reg offset_dir_locked = 0;      // Whether we have decided the error direction for this volley
    reg aim_high = 0;               // 0 = Aim Low, 1 = Aim High

    always @ (posedge clk_0) begin
        if (!rst) begin
            ai_ypos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
            reset_vel_count <= 0;
            reaction_count <= 0;
            offset_dir_locked <= 0;
        end else if (reset_game) begin
            ai_ypos <= (V_VIDEO / 2) - (PDL_HEIGHT / 2);
            vel_count <= 0;
            reset_vel_count <= 0;
            reaction_count <= 0;
            offset_dir_locked <= 0;
        end else begin
            // Check if the ball has started coming towards the AI
            if (sq_xveldir == 1'b1 && !sq_missed) begin
                // Reset return delay count
                return_count <= 0;
                
                // Lock in the error direction once per volley
                if (offset_dir_locked == 0) begin
                    aim_high <= lfsr_data[5]; // Decide if we overshoot or undershoot
                    offset_dir_locked <= 1;
                end

                // Continuously calculate the dynamic target based on live ball position
                if (aim_high) begin
                    // Check bounds to prevent overflow
                    if (sq_cent_y + difficulty_offset < V_VIDEO)
                        dynamic_target_y <= sq_cent_y + difficulty_offset;
                    else
                        dynamic_target_y <= V_VIDEO - 1;
                end else begin
                    if (sq_cent_y > difficulty_offset)
                        dynamic_target_y <= sq_cent_y - difficulty_offset;
                    else
                        dynamic_target_y <= 0;
                end

                // Wait for reaction time before moving
                if (reaction_count < REACTION_PSC) begin
                    reaction_count <= reaction_count + 1;
                end else begin
                    if (vel_count < PSC_LIMIT) begin
                        vel_count <= vel_count + 1;
                    end else begin
                        vel_count <= 0;
                        // Move paddle towards the dynamic target
                        // If paddle is below target, move up until it isn't
                        if (ai_cent_y > dynamic_target_y) begin
                            // Only move up if AI isn't at the top of the screen
                            if (ai_ypos > 0) begin
                                ai_ypos <= ai_ypos - 1;
                            end
                        // If paddle is above target, move down until it isn't
                        end else if (ai_cent_y < dynamic_target_y) begin
                            // Only move down is AI isn't at the bottom of the screen
                            if (ai_ypos < V_VIDEO - PDL_HEIGHT) begin
                                ai_ypos <= ai_ypos + 1;
                            end
                        end
                    end
                end
            end else if (sq_missed || sq_xveldir == 1'b0) begin
                reaction_count <= 0;
                offset_dir_locked <= 0; // Unlock for next hit
                
                // Move back towards the centre once return delay is over
                if (return_count < RETURN_PSC) begin
                    return_count <= return_count + 1;
                end else begin
                    if (reset_vel_count < RESET_PSC_LIMIT) begin
                        reset_vel_count <= reset_vel_count + 1;
                    end else begin
                        reset_vel_count <= 0;
                        // If paddle is below centre, move up until it isn't
                        if (ai_cent_y > V_VIDEO/2) begin
                            if (ai_ypos > 0)
                                ai_ypos <= ai_ypos - 1;
                        // If paddle is above square, move down until it isn't
                        end else if (ai_cent_y < V_VIDEO/2) begin
                            if (ai_ypos < V_VIDEO - PDL_HEIGHT)
                                ai_ypos <= ai_ypos + 1;
                        end
                    end
                end
            end
        end

    end

endmodule