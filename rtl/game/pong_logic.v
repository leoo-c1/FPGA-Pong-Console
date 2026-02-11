module pong_logic #(
     // Ball settings
    parameter INIT_XVEL = 300,  // Used at the start of every new game and round
    parameter MIN_XVEL = 600,   // Used for paddle centre hits
    parameter MAX_XVEL = 700,   // Maximum horizontal velocity in pixels/second for edge hits

    // Control settings
    parameter PDL_SPEED = 600,          // Speed of the player's paddle
    parameter AI_SPEED = 500,           // Speed of the AI's paddle
    parameter AI_RESET_SPEED = 300,     // Paddle vertical velocity moving back to centre post-hit
    parameter AI_REACTION_TIME = 700,   // Time (ms) the AI takes to react to the ball coming
    parameter RETURN_DELAY = 400,       // Time (ms) passed before AI returns to centre
    parameter MIN_OFFSET = 0,           // Minimum error in pixels (Sharpest aim)
    parameter MAX_OFFSET = 48,          // Maximum error in pixels (Sloppiest aim)
    parameter BASE_OFFSET = 6,          // Default error when scores are tied
    parameter SCALING_FACTOR = 3,       // How many pixels the error changes per point difference

    // Sprite settings
    parameter SQ_WIDTH = 16,
    parameter PDL_HEIGHT = 96,
    parameter PDL_WIDTH = 12
    ) (
    input clk_0,            // 25.175MHz clock
    input rst,              // Reset button

    // Player inputs (active low buttons)
    input wire up_p1,       // Player 1 up
    input wire down_p1,     // Player 1 down
    input wire up_p2,       // Player 2 up
    input wire down_p2,     // Player 2 down

    input wire [1:0] mode_choice,   // Gamemode choice, 0 = nothing, 1 = 1 player, 2 = 2 players
    input wire start_trigger,       // For triggering startup when any key is pressed

    // Coordinates for the top left corner of each sprite
    output reg [9:0] sq_xpos = h_video /2,
    output reg [9:0] sq_ypos = v_video/2,

    output wire [9:0] pdl1_xpos,
    output wire [9:0] pdl1_ypos,

    output wire [9:0] pdl2_xpos,
    output wire [9:0] pdl2_ypos,

    // Game states
    output reg sq_shown = 1'b1,     // Whether or not square should be shown
    output reg [3:0] score_p1 = 0,  // Player 1's score
    output reg [3:0] score_p2 = 0,  // Player 2's score
    output reg game_over = 1'b0,    // Whether or not the game is over
    output reg game_startup = 1'b1, // Whether or not the game is on the startup menu
    output reg sq_missed = 1'b1,    // If the we miss the square and it hits the left/right side
    output reg [6:0] hit_y = 0      // The distance from paddle centre to the square during a hit
    );

    parameter h_video = 640;        // Horizontal active video (in pixels)
    parameter v_video = 480;        // Vertical active video (in lines)

    // Control paddle movement
    // Player 1
    paddle_control #(
        .START_X(24),
        .PDL_SPEED(PDL_SPEED),
        .PDL_HEIGHT(PDL_HEIGHT)
        ) p1_move (
        .clk_0(clk_0), .rst(rst),
        .reset_game(game_startup | game_over),
        .mode_choice(2'b10),    // Forced to be multiplayer, paddle 1 is always player-controlled
        .move_up(up_p1), .move_down(down_p1),
        .sq_xpos(sq_xpos), .sq_ypos(sq_ypos),
        .sq_xveldir(sq_xveldir),
        .sq_missed(sq_missed),
        .score_p1(score_p1), .score_p2(score_p2),
        .x_pos(pdl1_xpos), .y_pos(pdl1_ypos)
    );

    /*
    // Uncomment this out for AI vs. AI control, comment out other p1_move
    paddle_control #(
        .START_X(24),
        .PDL_HEIGHT(PDL_HEIGHT),
        .AI_SPEED(AI_SPEED),
        .AI_RESET_SPEED(AI_RESET_SPEED),
        .AI_REACTION_TIME(AI_REACTION_TIME),
        .RETURN_DELAY(RETURN_DELAY),
        .MIN_OFFSET(MIN_OFFSET), .MAX_OFFSET(MAX_OFFSET),
        .BASE_OFFSET(BASE_OFFSET),
        .SCALING_FACTOR(SCALING_FACTOR)
        ) p1_move (
        .clk_0(clk_0), .rst(rst),
        .reset_game(game_startup | game_over),
        .mode_choice(2'b01),    // Forced to be multiplayer, paddle 1 is always player-controlled
        .move_up(up_p1), .move_down(down_p1),
        .sq_xpos(sq_xpos), .sq_ypos(sq_ypos),
        .sq_xveldir(~sq_xveldir),
        .sq_missed(sq_missed),
        .score_p1(score_p2), .score_p2(score_p1),
        .x_pos(pdl1_xpos), .y_pos(pdl1_ypos)
    );
    */

    // Player 2, either player-controlled or AI-controlled
    paddle_control #(
        .START_X(603),
        .PDL_HEIGHT(PDL_HEIGHT),
        .AI_SPEED(AI_SPEED),
        .AI_RESET_SPEED(AI_RESET_SPEED),
        .AI_REACTION_TIME(AI_REACTION_TIME),
        .RETURN_DELAY(RETURN_DELAY),
        .MIN_OFFSET(MIN_OFFSET), .MAX_OFFSET(MAX_OFFSET),
        .BASE_OFFSET(BASE_OFFSET),
        .SCALING_FACTOR(SCALING_FACTOR)
        ) p2_move (
        .clk_0(clk_0), .rst(rst),
        .reset_game(game_startup | game_over),
        .mode_choice(mode_choice),
        .move_up(up_p2), .move_down(down_p2),
        .sq_xpos(sq_xpos), .sq_ypos(sq_ypos),
        .sq_xveldir(sq_xveldir),
        .sq_missed(sq_missed),
        .score_p1(score_p1), .score_p2(score_p2),
        .x_pos(pdl2_xpos), .y_pos(pdl2_ypos)
    );

    // Square velocity setup
    parameter VEL_WIDTH = $clog2(MAX_XVEL + 1);  // Width of velocity register
    wire [VEL_WIDTH-1:0] sq_xvel;
    wire [VEL_WIDTH-1:0] sq_yvel;

    // Accumulators to store partial pixel progress.
    parameter VEL_THRESHOLD = 25_175_000;
    reg [24:0] x_acc = 0;
    reg [24:0] y_acc = 0;
    reg sq_xveldir = 1'b0;          // Square's direction of velocity along x, 0 = left, 1 = right
    reg sq_yveldir = 1'b0;          // Square's direction of velocity along y, 0 = up, 1 = down

    reg paddle_hit = 1'b0;          // Whether or not we just hit a paddle
    wire [9:0] sq_cent_y = sq_ypos + SQ_WIDTH/2;        // Center of square
    wire [9:0] pdl1_cent_y = pdl1_ypos + PDL_HEIGHT/2;  // Center of Left paddle
    wire [9:0] pdl2_cent_y = pdl2_ypos + PDL_HEIGHT/2;  // Center of Right paddle

    velocity_mapper #(
        .INIT_XVEL(INIT_XVEL),
        .MIN_XVEL(MIN_XVEL), .MAX_XVEL(MAX_XVEL),
        .VEL_WIDTH(VEL_WIDTH)
    ) sq_velocity(
        .clk_0(clk_0),
        .rst(rst),
        .paddle_hit(paddle_hit), .hit_y(hit_y),
        .sq_missed(sq_missed), .game_over(game_over), .game_startup(game_startup),
        .sq_xvel(sq_xvel), .sq_yvel(sq_yvel)
    );

    parameter delay_s = 2;                  // Delay on startup/point won/lost (seconds)
    parameter delay = 25_176_056*delay_s;   // Same delay in 25.175MHz clock cycles
    reg [26:0] delay_count = 0;             // Counts delay time

    parameter max_score = 11;               // The max score before game over

    parameter safe_start_time = 2_500_000;  // Time to stay on start menu before accepting inputs
    reg [21:0] safe_start_count = 0;

    // Helper task to reset game state
    task spawn_ball;
        begin
            sq_xpos <= h_video / 2;
            sq_xpos <= h_video / 2;
            sq_ypos <= rand_y;
            sq_xveldir <= 1'b0;
            sq_yveldir <= rand_y[0];
            x_acc <= 0;
            y_acc <= 0;
            paddle_hit <= 1'b0;
            hit_y <= 0;
            sq_shown <= 1'b0;
            sq_missed <= 1'b1;
            delay_count <= 0;
        end
    endtask

    // Pseudorandom number generator
    // Counts up and down between 100 and 380 to generate safe y coordinates
    reg [9:0] rand_y = 100;
    reg rand_dir = 0;       // Count direction

    always @(posedge clk_0) begin
        if (rand_dir == 0) begin
            if (rand_y < 380)
                rand_y <= rand_y + 1;
            else
                rand_dir <= 1;
        end else begin
            if (rand_y > 100)
                rand_y <= rand_y - 1;
            else
                rand_dir <= 0;
        end
    end

    always @ (posedge clk_0, negedge rst) begin
        if (!rst) begin        // If we reset
            // Reset the score and sprites' positions and velocities
            spawn_ball();
            score_p1 <= 0;
            score_p2 <= 0;
            game_over <= 1'b0;
            game_startup <= 1'b1;
            safe_start_count <= 0;
        end else if (game_over) begin   // If the game is over
            // Reset the score and sprites' positions and velocities
            spawn_ball();
            score_p1 <= 0;
            score_p2 <= 0;
            game_over <= 1'b1;
            game_startup <= 1'b0;
            safe_start_count <= 0;
            // Stay in game over until user presses buttons
            if (start_trigger) begin
                    game_over <= 1'b0;
                    end
        end else if (game_startup) begin    // If we're on the startup menu
            // Reset the score and sprites' positions and velocities
            spawn_ball();
            score_p1 <= 0;
            score_p2 <= 0;
            game_over <= 1'b0;
            game_startup <= 1'b1;
            // Stay in start up until user presses buttons (after safety delay passes)
            if (safe_start_count < 22'd2_500_000) begin
                safe_start_count <= safe_start_count + 1;
                game_startup <= 1'b1;
            // Only check buttons if the timer is finished
            end else begin 
                    if (start_trigger) begin
                    game_startup <= 1'b0;
                    end
            end
        end else begin
            paddle_hit <= 1'b0;         // Default to no hit

            // Square collision with right wall
            if (sq_xpos >= h_video - SQ_WIDTH - 1) begin    // Respawn ball
                spawn_ball();
                sq_xveldir <= 1'b1;                         // Let P2 start with the ball
                if (score_p1 < max_score - 1) begin         // Increment score if possible
                    score_p1 <= score_p1 + 1;
                    game_over <= 1'b0;
                end else begin                              // Game over when max score reached
                    game_over <= 1'b1;
                end

            // Square collision with left wall
            end else if (sq_xpos <= 0) begin
                spawn_ball();
                if (score_p2 < max_score - 1) begin
                    score_p2 <= score_p2 + 1;
                    game_over <= 1'b0;
                end else begin
                    game_over <= 1'b1;
                end
            
            end else if (sq_ypos >= v_video - SQ_WIDTH - 1) begin    // If we hit the bottom wall
                sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                sq_ypos <= sq_ypos - 1;     // Move up by one pixel

            end else if (sq_ypos <= 0) begin    // If we hit the top wall
                sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                sq_ypos <= sq_ypos + 1;     // Move down one pixel

            // Square collision with right paddle
            // Check if the left/right side of the square hits
            end else if (sq_xpos + SQ_WIDTH >= pdl2_xpos && 
                        sq_xpos <= pdl2_xpos + PDL_WIDTH) begin
                // Check if the top/bottom right corner of the square hits the paddle
                if (sq_ypos <= pdl2_ypos + PDL_HEIGHT && 
                    sq_ypos + SQ_WIDTH >= pdl2_ypos) begin
                    // Check if top of the square is hitting the bottom of the paddle
                    if (sq_ypos == pdl2_ypos + PDL_HEIGHT ||
                        sq_ypos == pdl2_ypos + PDL_HEIGHT - 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos + 1;     // Move down one pixel
                        hit_y <= PDL_HEIGHT/2;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + SQ_WIDTH == pdl2_ypos || 
                                sq_ypos + SQ_WIDTH == pdl2_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= PDL_HEIGHT/2;

                    end else begin
                        paddle_hit <= 1'b1;
                        sq_xveldir <= ~sq_xveldir;  // Change direction along x-axis
                        sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel

                        // Check if the square hits below the paddle's centre
                        if (sq_cent_y >= pdl2_cent_y) begin
                            sq_yveldir <= 1'b1;     // Send the square down
                            // Calculate Distance
                            if ((sq_cent_y - pdl2_cent_y) > PDL_HEIGHT/2)
                                hit_y <= PDL_HEIGHT/2; // Clamp to max range
                            else
                                hit_y <= sq_cent_y - pdl2_cent_y;

                        end else begin // If we are at/above the paddle's centre
                            sq_yveldir <= 1'b0;     // Send the square up
                            // Calculate Distance
                            if ((pdl2_cent_y - sq_cent_y) > PDL_HEIGHT/2)
                                hit_y <= PDL_HEIGHT/2; // Clamp to max range
                            else
                                hit_y <= pdl2_cent_y - sq_cent_y;
                        end
                    end
                end

            // Square collision with left paddle
            // Check if the left/right side of the square hits
            end else if (sq_xpos <= pdl1_xpos + PDL_WIDTH + 1 && 
                        sq_xpos + SQ_WIDTH >= pdl1_xpos) begin
                // If top/bottom left corner of the square is hitting the left paddle's right side
                if (sq_ypos <= pdl1_ypos + PDL_HEIGHT && 
                    sq_ypos + SQ_WIDTH >= pdl1_ypos) begin
                    // Check if top of the square is hitting the bottom of the paddle
                    if (sq_ypos == pdl1_ypos + PDL_HEIGHT ||
                        sq_ypos == pdl1_ypos + PDL_HEIGHT - 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos + 1;     // Move down one pixel
                        hit_y <= PDL_HEIGHT/2;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + SQ_WIDTH == pdl1_ypos || 
                                sq_ypos + SQ_WIDTH == pdl1_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= PDL_HEIGHT/2;

                    end else begin
                        paddle_hit <= 1'b1;
                        sq_xveldir <= ~sq_xveldir;  // Change direction along y-axis
                        sq_xpos <= sq_xpos + 1;     // Move to the right one pixel

                        // Check if the square hits below the paddle's centre
                        if (sq_cent_y >= pdl1_cent_y) begin
                            sq_yveldir <= 1'b1;     // Send the square down
                            // Calculate distance
                            if ((sq_cent_y - pdl1_cent_y) > PDL_HEIGHT/2)
                                hit_y <= PDL_HEIGHT/2;
                            else
                                hit_y <= sq_cent_y - pdl1_cent_y;

                        end else begin // If we are at/above the paddle's centre
                            sq_yveldir <= 1'b0;     // Send the square up
                            // Calculate distance
                            if ((pdl1_cent_y - sq_cent_y) > PDL_HEIGHT/2)
                                hit_y <= PDL_HEIGHT/2;
                            else
                                hit_y <= pdl1_cent_y - sq_cent_y;
                        end
                    end
                end
            end

            if (sq_missed) begin
                if (delay_count < delay) begin
                    sq_shown <= 1'b0;
                    delay_count <= delay_count + 1;
                end else begin
                    sq_shown <= 1'b1;
                    sq_missed <= 1'b0;
                    delay_count <= 0;
                end
            end

            if (sq_shown) begin         // Only update square if it is being shown
                // Control square's x position
                if (x_acc < VEL_THRESHOLD) begin
                    x_acc <= x_acc + sq_xvel;
                end else begin          // Increment square position every velocity tick
                    x_acc <= x_acc - VEL_THRESHOLD + sq_xvel;
                    sq_xpos <= sq_xpos + 2*sq_xveldir - 1;  // sq_xveldir: 0 = left, 1 = right
                end

                // Control square's y position
                if (y_acc < VEL_THRESHOLD) begin
                    y_acc <= y_acc + sq_yvel;
                end else begin          // Increment square position every velocity tick
                    y_acc <= y_acc - VEL_THRESHOLD + sq_yvel;
                    sq_ypos <= sq_ypos + 2*sq_yveldir - 1;  // sq_yveldir: 0 = up, 1 = down
                end
            end

        end

    end

endmodule