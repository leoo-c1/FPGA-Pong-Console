/*
Plan:
When the ball hits a paddle, we need to know where this hit happened on the paddle.
We will label this hit_y. We don't necessarily care about hit_x,
as shots on the bottom/top of the paddle will just act shots high up on the paddle
(larger velocity)

So velocity mapper needs to take in hit_y as an input.
This hit_y is relative to the center of the paddle.
We will also pass in two booleans: above_centre and below_centre.

This means we don't need to worry about storing hit_y as negative as well as positive.
We just consider whether it was above or below centre when hit_y was returned.

Good horizontal baseline at hit_y = 0: 200 pixels/sec

*/

module velocity_mapper #(
    parameter DEFAULT_VEL = 200 // Used for reset, square missed, centre hit, startup and game over
    ) (
    input clk_0,                // 25.175MHz clock
    input rst,                  // Reset key

    // Coordinates for the top left corner of each sprite
    input wire [9:0] sq_xpos,
    input wire [9:0] sq_ypos,

    input wire [9:0] pdl1_xpos,
    input wire [9:0] pdl1_ypos,

    input wire [9:0] pdl2_xpos,
    input wire [9:0] pdl2_ypos,

    input wire [6:0] hit_y,     // The distance from paddle centre to the ball during a hit
    input above_centre,         // Whether or not the ball hit above the paddle's centre
    input below_centre,         // Whether or not the ball hit below the paddle's centre

    input sq_missed,
    input game_over,            // Whether or not the game is over
    input game_startup,         // Whether or not the game is on the startup menu

    output reg [8:0] sq_xvel,   // Squares's horizontal velocity in pixels/second
    output reg sq_xveldir,      // Square's direction of velocity along x, 0 = left, 1 = right

    output reg [8:0] sq_yvel,   // Squares's vertical velocity in pixels/second
    output reg sq_yveldir,      // Square's direction of velocity along y, 0 = up, 1 = down
    );

    parameter sq_width = 16;    // The side lengths of the square
    parameter pdl_width = 12;   // The thickness of the paddle
    parameter pdl_height = 96;  // The height of the paddle 

    always @ (posedge clk_0) begin
        if (!rst) begin         // If we reset, set velocities to default velocity
            sq_xvel <= DEFAULT_VEL;
            sq_yvel <= DEFAULT_VEL;
        end else if (sq_missed | game_over | game_startup) begin
            sq_xvel <= DEFAULT_VEL;
            sq_yvel <= DEFAULT_VEL;
        end else begin
            // Square collision with right paddle
            // Check if the left/right side of the square hits
            if (sq_xpos + sq_width >= pdl2_xpos && 
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
                        above_centre <= 1'b0;
                        below_centre <= 1'b1;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl2_ypos || 
                                sq_ypos + sq_width == pdl2_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2
                        above_centre <= 1'b1;
                        below_centre <= 1'b0;

                    end else begin
                        sq_xveldir <= ~sq_xveldir;  // Change direction along x-axis
                        sq_xpos <= sq_xpos - 1;     // Move to the left by one pixel
                        // Check if the square hits below the paddle's centre
                        if (sq_ypos >= padl2_ypos + pdl_height/2) begin
                            hit_y <= sq_ypos - padl2_ypos - pdl_height/2 + 1;
                            above_centre <= 1'b0;
                            below_centre <= 1'b1;
                        end else begin // If we are at/above the paddle's centre
                            hit_y <= padl2_ypos + pdl_height/2 - sq_ypos - sq_width + 1;
                            above_centre <= 1'b1;
                            below_centre <= 1'b0;
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
                        above_centre <= 1'b0;
                        below_centre <= 1'b1;
                    
                    // Check if bottom of the square is hitting the top of the paddle
                    end else if (sq_ypos + sq_width == pdl1_ypos || 
                                sq_ypos + sq_width == pdl1_ypos + 1) begin
                        sq_yveldir <= ~sq_yveldir;  // Change direction along y-axis
                        sq_ypos <= sq_ypos - 1;     // Move up by one pixel
                        hit_y <= pdl_height/2
                        above_centre <= 1'b1;
                        below_centre <= 1'b0;

                    end else begin
                        sq_xveldir <= ~sq_xveldir;  // Change direction along y-axis
                        sq_xpos <= sq_xpos + 1;     // Move to the right one pixel
                        // Check if the square hits below the paddle's centre
                        if (sq_ypos >= padl1_ypos + pdl_height/2) begin
                            hit_y <= sq_ypos - padl1_ypos - pdl_height/2 + 1;
                            above_centre <= 1'b0;
                            below_centre <= 1'b1;
                        end else begin // If we are at/above the paddle's centre
                            hit_y <= padl1_ypos + pdl_height/2 - sq_ypos - sq_width + 1;
                            above_centre <= 1'b1;
                            below_centre <= 1'b0;
                        end
                    end
                end
            end
        end
    end
    
endmodule