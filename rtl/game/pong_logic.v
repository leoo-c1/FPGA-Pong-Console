module pong_logic (
    input clk_0,            // 25MHz clock
    input rst,              // Reset button

    // Player 1's inputs (active low buttons)
    input wire up_p1,
    input wire down_p1,

    // Player 2's inputs (active low buttons)
    input wire up_p2,
    input wire down_p2,

    // Coordinates for the top left corner of each sprite
    output reg [9:0] sq_xpos = h_video /2,
    output reg [9:0] sq_ypos = v_video/2,

    output reg [9:0] pdl1_xpos = 24,
    output reg [9:0] pdl1_ypos = 191,

    output reg [9:0] pdl2_xpos = 603,
    output reg [9:0] pdl2_ypos = 191
    );

    parameter h_video = 640;        // Horizontal active video (in pixels)
    parameter v_video = 480;        // Vertical active video (in lines)

    parameter sq_width = 16;        // The side lengths of the square
    parameter pdl_width = 12;       // The thickness of the paddle
    parameter pdl_height = 96;      // The height of the paddle 

    // Square velocity setup
    parameter sq_vel = 200;                     // Squares's velocity in pixels/second
    parameter sq_vel_psc = 25_175_000/sq_vel;   // Clock prescaler for square's velocity
    reg [18:0] sq_vel_count = 0;                // Velocity ticker
    reg sq_xvel = 1'b0;         // Square's direction of velocity along x, 0 = left, 1 = right
    reg sq_yvel = 1'b0;         // Square's direction of velocity along y, 0 = up, 1 = down

    // Paddle velocity setup
    parameter pdl_vel = 200;                        // Paddles' velocities in pixels/second
    parameter pdl_vel_psc = 25_175_000/pdl_vel;     // Clock prescaler for paddles' velocities
    reg [18:0] pdl1_vel_count = 0;                  // Left paddle's velocity ticker
    reg [18:0] pdl2_vel_count = 0;                  // Right paddle's velocity ticker
    reg pdl1_yvel = 1'b0;           // Left paddle's velocity direction along y, 0 = up, 1 = down
    reg pdl2_yvel = 1'b0;           // Right paddle's velocity direction along y, 0 = up, 1 = down

    always @ (posedge clk_0) begin
        if (!rst) begin             // If we press the reset button
            // Reset the score and sprites' positions and velocities
            sq_xpos <= h_video /2;
            sq_ypos <= v_video /2;
            sq_vel_count <= 0;
            sq_xvel <= 1'b0;
            sq_yvel <= 1'b0;
            pdl1_xpos <= 24;
            pdl1_ypos <= 191;
            pdl2_xpos <= 603;
            pdl2_ypos <= 191;

        // Square collision with right wall
        end else if (sq_xpos >= h_video - sq_width - 1) begin
            sq_xvel <= ~sq_xvel;        // Change direction along x-axis
            sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel

        // Square collision with left wall
        end else if (sq_xpos <= 0) begin
            sq_xvel <= ~sq_xvel;        // Change direction along y-axis
            sq_xpos <= sq_xpos + 1;     // Move to the right one pixel
        
        // Square collision with left paddle
        end else if (sq_xpos <= pdl1_xpos + pdl_width + 1 && 
                    sq_xpos + sq_width >= pdl1_xpos) begin
            // If top/bottom left corner of the square is hitting the left paddle's right side
            if (sq_ypos <= pdl1_ypos + pdl_height && 
                sq_ypos + sq_width >= pdl1_ypos) begin
                // Check if top of the square is hitting the bottom of the paddle
                if (sq_ypos == pdl1_ypos + pdl_height ||
                    sq_ypos == pdl1_ypos + pdl_height - 1) begin
                    sq_yvel <= ~sq_yvel;        // Change direction along y-axis
                    sq_ypos <= sq_ypos + 1;     // Move down one pixel
                
                // Check if bottom of the square is hitting the top of the paddle
                end else if (sq_ypos + sq_width == pdl1_ypos || 
                             sq_ypos + sq_width == pdl1_ypos + 1) begin
                    sq_yvel <= ~sq_yvel;        // Change direction along y-axis
                    sq_ypos <= sq_ypos - 1;     // Move up by one pixel

                end else begin
                    sq_xvel <= ~sq_xvel;        // Change direction along y-axis
                    sq_xpos <= sq_xpos + 1;     // Move to the right one pixel
                end
            end 

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
                    sq_yvel <= ~sq_yvel;        // Change direction along y-axis
                    sq_ypos <= sq_ypos + 1;     // Move down one pixel
                
                // Check if bottom of the square is hitting the top of the paddle
                end else if (sq_ypos + sq_width == pdl2_ypos || 
                             sq_ypos + sq_width == pdl2_ypos + 1) begin
                    sq_yvel <= ~sq_yvel;        // Change direction along y-axis
                    sq_ypos <= sq_ypos - 1;     // Move up by one pixel

                end else begin
                    sq_xvel <= ~sq_xvel;        // Change direction along x-axis
                    sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel
                end
            end
        end

        if (sq_ypos >= v_video - sq_width - 1) begin    // If we hit the bottom wall
            sq_yvel <= ~sq_yvel;        // Change direction along y-axis
            sq_ypos <= sq_ypos - 1;     // Move up by one pixel

        end else if (sq_ypos <= 0) begin    // If we hit the top wall
            sq_yvel <= ~sq_yvel;        // Change direction along y-axis
            sq_ypos <= sq_ypos + 1;     // Move down one pixel
        end

        // Control square's x and y position
        if (sq_vel_count < sq_vel_psc) begin
            sq_vel_count <= sq_vel_count + 1;
        end else begin              // Increment square position every velocity tick
            sq_vel_count <= 0;
            sq_xpos <= sq_xpos + 2*sq_xvel - 1;
            sq_ypos <= sq_ypos + 2*sq_yvel - 1;
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

endmodule