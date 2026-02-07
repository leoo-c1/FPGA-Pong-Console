module pong_logic (
    input clk_0,            // 25.175MHz clock
    input rst,              // Reset button

    // Player inputs (active low buttons)
    input wire up_p1,       // Player 1 up
    input wire down_p1,     // Player 1 down
    input wire up_p2,       // Player 2 up
    input wire down_p2,     // Player 2 down

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

    parameter sq_width = 16;        // The side lengths of the square
    parameter pdl_width = 12;       // The thickness of the paddle
    parameter pdl_height = 96;      // The height of the paddle

    // Control paddle movement
    paddle_control #(
        .START_X(24)
        ) p1_move (
        .clk(clk_0), .rst(rst),
        .reset_game(game_startup | game_over),
        .move_up(up_p1), .move_down(down_p1),
        .x_pos(pdl1_xpos), .y_pos(pdl1_ypos)
    );

    paddle_control #(
        .START_X(603)
        ) p2_move (
        .clk(clk_0), .rst(rst),
        .reset_game(game_startup | game_over),
        .move_up(up_p2), .move_down(down_p2),
        .x_pos(pdl2_xpos), .y_pos(pdl2_ypos)
    );

    // Square velocity setup
    parameter INIT_XVEL = 300;  // Used on reset, startup or game over
    parameter MIN_XVEL = 500;   // Used for reset, square missed, centre hit, startup and game over
    parameter MAX_XVEL = 600;   // Maximum horizontal velocity in pixels/second for edge hits
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
    wire [9:0] sq_cent_y = sq_ypos + sq_width/2;        // Center of square
    wire [9:0] pdl1_cent_y = pdl1_ypos + pdl_height/2;  // Center of Left paddle
    wire [9:0] pdl2_cent_y = pdl2_ypos + pdl_height/2;  // Center of Right paddle

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

    parameter safe_start_time = 2_500_000;
    reg [21:0] safe_start_count = 0;

    // Helper task to reset game state
    task spawn_ball;
        begin
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
            if (up_p1 || down_p1 || up_p2 || down_p2) begin
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
                    if (up_p1 || down_p1 || up_p2 || down_p2) begin
                    game_startup <= 1'b0;
                    end
            end
        end else begin
            paddle_hit <= 1'b0;         // Default to no hit

            // Square collision with right wall
            if (sq_xpos >= h_video - sq_width - 1) begin // Respawn ball
                spawn_ball();
                if (score_p1 < max_score - 1) begin
                    score_p1 <= score_p1 + 1;
                    game_over <= 1'b0;
                end else begin
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
            
            end else if (sq_ypos >= v_video - sq_width - 1) begin    // If we hit the bottom wall
                sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                sq_ypos <= sq_ypos - 1;     // Move up by one pixel

            end else if (sq_ypos <= 0) begin    // If we hit the top wall
                sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                sq_ypos <= sq_ypos + 1;     // Move down one pixel

            // Square collision with right paddle
            // Check if the left/right side of the square hits
            end else if (sq_xpos + sq_width >= pdl2_xpos && 
                        sq_xpos <= pdl2_xpos + pdl_width) begin
                // Check if the top/bottom right corner of the square hits the paddle
                if (sq_ypos <= pdl2_ypos + pdl_height && 
                    sq_ypos + sq_width >= pdl2_ypos) begin
                    // Check if top of the square is hitting the bottom of the paddle
                    if (sq_ypos == pdl2_ypos + pdl_height ||
                        sq_ypos == pdl2_ypos + pdl_height - 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos + 1;     // Move down one pixel
                        hit_y <= pdl_height/2;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl2_ypos || 
                                sq_ypos + sq_width == pdl2_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2;

                    end else begin
                        paddle_hit <= 1'b1;
                        sq_xveldir <= ~sq_xveldir;  // Change direction along x-axis
                        sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel

                        // Check if the square hits below the paddle's centre
                        if (sq_cent_y >= pdl2_cent_y) begin
                            sq_yveldir <= 1'b1;     // Send the square down
                            // Calculate Distance
                            if ((sq_cent_y - pdl2_cent_y) > pdl_height/2)
                                hit_y <= pdl_height/2; // Clamp to max range
                            else
                                hit_y <= sq_cent_y - pdl2_cent_y;

                        end else begin // If we are at/above the paddle's centre
                            sq_yveldir <= 1'b0;     // Send the square up
                            // Calculate Distance
                            if ((pdl2_cent_y - sq_cent_y) > pdl_height/2)
                                hit_y <= pdl_height/2; // Clamp to max range
                            else
                                hit_y <= pdl2_cent_y - sq_cent_y;
                        end
                    end
                end

            // Square collision with left paddle
            // Check if the left/right side of the square hits
            end else if (sq_xpos <= pdl1_xpos + pdl_width + 1 && 
                        sq_xpos + sq_width >= pdl1_xpos) begin
                // If top/bottom left corner of the square is hitting the left paddle's right side
                if (sq_ypos <= pdl1_ypos + pdl_height && 
                    sq_ypos + sq_width >= pdl1_ypos) begin
                    // Check if top of the square is hitting the bottom of the paddle
                    if (sq_ypos == pdl1_ypos + pdl_height ||
                        sq_ypos == pdl1_ypos + pdl_height - 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos + 1;     // Move down one pixel
                        hit_y <= pdl_height/2;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl1_ypos || 
                                sq_ypos + sq_width == pdl1_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2;

                    end else begin
                        paddle_hit <= 1'b1;
                        sq_xveldir <= ~sq_xveldir;  // Change direction along y-axis
                        sq_xpos <= sq_xpos + 1;     // Move to the right one pixel

                        // Check if the square hits below the paddle's centre
                        if (sq_cent_y >= pdl1_cent_y) begin
                            sq_yveldir <= 1'b1;     // Send the square down
                            // Calculate distance
                            if ((sq_cent_y - pdl1_cent_y) > pdl_height/2)
                                hit_y <= pdl_height/2;
                            else
                                hit_y <= sq_cent_y - pdl1_cent_y;

                        end else begin // If we are at/above the paddle's centre
                            sq_yveldir <= 1'b0;     // Send the square up
                            // Calculate distance
                            if ((pdl1_cent_y - sq_cent_y) > pdl_height/2)
                                hit_y <= pdl_height/2;
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