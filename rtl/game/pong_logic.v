module pong_logic (
    input clk_0,            // 25.175MHz clock
    input rst,              // Reset button

    // Player inputs (active low buttons)
    input wire up_p1,       // Player 1 up
    input wire down_p1,     // Player 1 down
    input wire up_p2,       // Player 2 up
    input wire down_p2,     // Player 2 down

    // Ball velocity


    // Coordinates for the top left corner of each sprite
    output reg [9:0] sq_xpos = h_video /2,
    output reg [9:0] sq_ypos = v_video/2,

    output reg [9:0] pdl1_xpos = 24,
    output reg [9:0] pdl1_ypos = 191,

    output reg [9:0] pdl2_xpos = 603,
    output reg [9:0] pdl2_ypos = 191,

    // Game states
    output reg sq_shown = 1'b1,     // Whether or not square should be shown
    output reg [3:0] score_p1 = 0,  // Player 1's score
    output reg [3:0] score_p2 = 0,  // Player 2's score
    output reg game_over = 1'b0,    // Whether or not the game is over
    output reg game_startup = 1'b1, // Whether or not the game is on the startup menu
    output reg sq_missed = 1'b1,    // If the we miss the square and it hits the left/right side

    // Ball collision point
    output reg [6:0] hit_y,         // The distance from paddle centre to the ball during a hit
    );

    parameter h_video = 640;        // Horizontal active video (in pixels)
    parameter v_video = 480;        // Vertical active video (in lines)

    parameter sq_width = 16;        // The side lengths of the square
    parameter pdl_width = 12;       // The thickness of the paddle
    parameter pdl_height = 96;      // The height of the paddle 

    // Square velocity setup
    parameter sq_xvel = 200;                    // Squares's horizontal velocity in pixels/second
    parameter sq_yvel = 200;                    // Squares's vertical velocity in pixels/second
    parameter sq_xvel_psc = 25_175_000/sq_xvel; // Clock prescaler for horizontal square velocity
    parameter sq_yvel_psc = 25_175_000/sq_yvel; // Clock prescaler for vertical square velocity
    reg [18:0] sq_xvel_count = 0;               // Horizontal velocity ticker
    reg [18:0] sq_yvel_count = 0;               // Vertical velocity ticker
    reg sq_xveldir = 1'b0;          // Square's direction of velocity along x, 0 = left, 1 = right
    reg sq_yveldir = 1'b0;          // Square's direction of velocity along y, 0 = up, 1 = down

    // Paddle velocity setup
    parameter pdl_vel = 400;                        // Paddles' velocities in pixels/second
    parameter pdl_vel_psc = 25_175_000/pdl_vel;     // Clock prescaler for paddles' velocities
    reg [18:0] pdl1_vel_count = 0;                  // Left paddle's velocity ticker
    reg [18:0] pdl2_vel_count = 0;                  // Right paddle's velocity ticker
    reg pdl1_yvel = 1'b0;           // Left paddle's velocity direction along y, 0 = up, 1 = down
    reg pdl2_yvel = 1'b0;           // Right paddle's velocity direction along y, 0 = up, 1 = down

    parameter delay_s = 2;                  // Delay on startup/point won/lost (seconds)
    parameter delay = 25_176_056*delay_s;   // Same delay in 25.175MHz clock cycles
    reg [26:0] delay_count = 0;             // Counts delay time

    parameter max_score = 11;               // The max score before game over

    parameter safe_start_time = 2_500_000;
    reg [21:0] safe_start_count = 0;

    always @ (posedge clk_0, negedge rst) begin
        if (!rst) begin        // If we reset
            // Reset the score and sprites' positions and velocities
            sq_xpos <= h_video /2;
            sq_ypos <= v_video /2;
            sq_xvel_count <= 0;
            sq_yvel_count <= 0;
            pdl1_vel_count <= 0;
            pdl2_vel_count <= 0;
            sq_xveldir <= 1'b0;
            sq_yveldir <= 1'b0;
            pdl1_xpos <= 24;
            pdl1_ypos <= 191;
            pdl2_xpos <= 603;
            pdl2_ypos <= 191;
            sq_shown <= 1'b0;
            sq_missed <= 1'b1;
            delay_count <= 0;
            score_p1 <= 0;
            score_p2 <= 0;
            game_over <= 1'b0;
            game_startup <= 1'b1;
            safe_start_count <= 0;
        end else if (game_over) begin   // If the game is over
            // Reset the score and sprites' positions and velocities
            sq_xpos <= h_video /2;
            sq_ypos <= v_video /2;
            sq_xvel_count <= 0;
            sq_yvel_count <= 0;
            pdl1_vel_count <= 0;
            pdl2_vel_count <= 0;
            sq_xveldir <= 1'b0;
            sq_yveldir <= 1'b0;
            pdl1_xpos <= 24;
            pdl1_ypos <= 191;
            pdl2_xpos <= 603;
            pdl2_ypos <= 191;
            sq_shown <= 1'b0;
            sq_missed <= 1'b1;
            delay_count <= 0;
            score_p1 <= 0;
            score_p2 <= 0;
            game_over <= 1'b1;
            game_startup <= 1'b0;
            safe_start_count <= 0;
            // Stay in game over until user presses buttons
            if (!up_p1 || !down_p1 || !up_p2 || !down_p2) begin
                    game_over <= 1'b0;
                    end
        end else if (game_startup) begin    // If we're on the startup menu
            // Reset the score and sprites' positions and velocities
            sq_xpos <= h_video /2;
            sq_ypos <= v_video /2;
            sq_xvel_count <= 0;
            sq_yvel_count <= 0;
            pdl1_vel_count <= 0;
            pdl2_vel_count <= 0;
            sq_xveldir <= 1'b0;
            sq_yveldir <= 1'b0;
            pdl1_xpos <= 24;
            pdl1_ypos <= 191;
            pdl2_xpos <= 603;
            pdl2_ypos <= 191;
            sq_shown <= 1'b0;
            sq_missed <= 1'b1;
            delay_count <= 0;
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
                    if (!up_p1 || !down_p1 || !up_p2 || !down_p2) begin
                    game_startup <= 1'b0;
                    end
            end
        end else begin
            // Square collision with right wall
            if (sq_xpos >= h_video - sq_width - 1) begin // Reset game state
                sq_missed <= 1'b1;
                sq_xpos <= h_video /2;
                sq_ypos <= v_video /2;
                sq_xvel_count <= 0;
                sq_yvel_count <= 0;
                sq_xveldir <= 1'b0;
                sq_yveldir <= 1'b0;
                if (score_p1 < max_score - 1) begin
                    score_p1 <= score_p1 + 1;
                    game_over <= 1'b0;
                end else begin
                    game_over <= 1'b1;
                end

            // Square collision with left wall
            end else if (sq_xpos <= 0) begin
                sq_missed <= 1'b1;
                sq_xpos <= h_video /2;
                sq_ypos <= v_video /2;
                sq_xvel_count <= 0;
                sq_yvel_count <= 0;
                sq_xveldir <= 1'b0;
                sq_yveldir <= 1'b0;
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
                        hit_y <= pdl_height/2
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl2_ypos || 
                                sq_ypos + sq_width == pdl2_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2

                    end else begin
                        sq_xveldir <= ~sq_xveldir;  // Change direction along x-axis
                        sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel
                        // Check if the square hits below the paddle's centre
                        if (sq_ypos >= padl2_ypos + pdl_height/2) begin
                            hit_y <= sq_ypos - padl2_ypos - pdl_height/2 + 1;
                            sq_yveldir <= 1'b1;
                        end else begin // If we are at/above the paddle's centre
                            hit_y <= padl2_ypos + pdl_height/2 - sq_ypos - sq_width + 1;
                            sq_yveldir <= 1'b0;
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
                        hit_y <= pdl_height/2
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl1_ypos || 
                                sq_ypos + sq_width == pdl1_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2

                    end else begin
                        sq_xveldir <= ~sq_xveldir;  // Change direction along y-axis
                        sq_xpos <= sq_xpos + 1;     // Move to the right one pixel
                        // Check if the square hits below the paddle's centre
                        if (sq_ypos >= padl1_ypos + pdl_height/2) begin
                            hit_y <= sq_ypos - padl1_ypos - pdl_height/2 + 1;
                            sq_yveldir <= 1'b1;
                        end else begin // If we are at/above the paddle's centre
                            hit_y <= padl1_ypos + pdl_height/2 - sq_ypos - sq_width + 1;
                            sq_yveldir <= 1'b0;
                        end
                    end
                end
            end

            if (sq_missed) begin
                if (delay_count < delay) begin
                    sq_shown <= 1'b0;
                    sq_xpos <= h_video /2;
                    sq_ypos <= v_video /2;
                    delay_count <= delay_count + 1;
                end else begin
                    sq_shown <= 1'b1;
                    sq_missed <= 1'b0;
                    sq_xpos <= h_video /2;
                    sq_ypos <= v_video /2;
                    delay_count <= 0;
                end
            end

            if (sq_shown) begin         // Only update square if it is being shown
                // Control square's x position
                if (sq_xvel_count < sq_xvel_psc) begin
                    sq_xvel_count <= sq_xvel_count + 1;
                end else begin          // Increment square position every velocity tick
                    sq_xvel_count <= 0;
                    sq_xpos <= sq_xpos + 2*sq_xveldir - 1;  // sq_xveldir: 0 = left, 1 = right
                end

                // Control square's y position
                if (sq_yvel_count < sq_yvel_psc) begin
                    sq_yvel_count <= sq_yvel_count + 1;
                end else begin          // Increment square position every velocity tick
                    sq_yvel_count <= 0;
                    sq_ypos <= sq_ypos + 2*sq_yveldir - 1;  // sq_yveldir: 0 = up, 1 = down
                end
            end
            

            // Control left paddle's x and y position
            if (!up_p1) begin           // If player 1 presses up
                if (down_p1) begin      // And is not pressing down at the same time
                    pdl1_yvel <= 0;
                    if (pdl1_vel_count < pdl_vel_psc) begin
                        pdl1_vel_count <= pdl1_vel_count + 1;
                    end else begin              // Increment paddle position every velocity tick
                        pdl1_vel_count <= 0;
                        // Make sure we aren't at the top of the screen
                        if (pdl1_ypos > 0) begin
                            pdl1_ypos <= pdl1_ypos + 2*pdl1_yvel - 1;
                        end
                    end
                end
            end else if (!down_p1) begin    // If player 1 presses down and wasn't pressing up
                pdl1_yvel <= 1;
                if (pdl1_vel_count < pdl_vel_psc) begin
                    pdl1_vel_count <= pdl1_vel_count + 1;
                end else begin              // Increment paddle position every velocity tick
                    pdl1_vel_count <= 0;
                    // Make sure we aren't at the bottom of the screen
                    if (pdl1_ypos + pdl_height < v_video - 1) begin
                        pdl1_ypos <= pdl1_ypos + 2*pdl1_yvel - 1;
                    end
                end
            end

            // Control right paddle's x and y position
            if (!up_p2) begin           // If player 2 presses up
                if (down_p2) begin      // And is not pressing down at the same time
                    pdl2_yvel <= 0;
                    if (pdl2_vel_count < pdl_vel_psc) begin
                        pdl2_vel_count <= pdl2_vel_count + 1;
                    end else begin              // Increment paddle position every velocity tick
                        pdl2_vel_count <= 0;
                        // Make sure we aren't at the top of the screen
                        if (pdl2_ypos > 0) begin
                            pdl2_ypos <= pdl2_ypos + 2*pdl2_yvel - 1;
                        end
                    end
                end
            end else if (!down_p2) begin    // If player 2 presses down and wasn't pressing up
                pdl2_yvel <= 1;
                if (pdl2_vel_count < pdl_vel_psc) begin
                    pdl2_vel_count <= pdl2_vel_count + 1;
                end else begin              // Increment paddle position every velocity tick
                    pdl2_vel_count <= 0;
                    // Make sure we aren't at the bottom of the screen
                    if (pdl2_ypos + pdl_height < v_video - 1) begin
                        pdl2_ypos <= pdl2_ypos + 2*pdl2_yvel - 1;
                    end
                end
            end
        end

    end

endmodule