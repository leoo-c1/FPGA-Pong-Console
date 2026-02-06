module velocity_mapper #(
    parameter MIN_VEL = 400,    // Used for reset, square missed, centre hit, startup and game over
    parameter MAX_VEL = 600,    // Maximum velocity in pixels/second for edge hits
    parameter VEL_WIDTH = $clog2(MAX_VEL + 1)   // Width of velocity register
    ) (
    input clk_0,                // 25.175MHz clock
    input rst,                  // Reset key

    input wire paddle_hit,      // Whether or not we just hit a paddle
    input wire [6:0] hit_y,     // The distance from paddle centre to the square during a hit

    input sq_missed,            // Whether or not the square went out of bounds
    input game_over,            // Whether or not the game is over
    input game_startup,         // Whether or not the game is on the startup menu

    output reg [VEL_WIDTH-1:0] sq_xvel,     // Squares's horizontal velocity in pixels/second
    output reg [VEL_WIDTH-1:0] sq_yvel      // Squares's vertical velocity in pixels/second
    );

    parameter pdl_height = 96;

    parameter SCALE_VELX = 2 * (MAX_VEL - MIN_VEL) / pdl_height;
    parameter SCALE_VELY = 2 * MAX_VEL / pdl_height;

    always @ (posedge clk_0) begin
        if (!rst) begin         // If we reset, set velocities to default velocity
            sq_xvel <= MIN_VEL;
            sq_yvel <= MIN_VEL;
        end else if (sq_missed | game_over | game_startup) begin
            sq_xvel <= MIN_VEL;
            sq_yvel <= MIN_VEL;
        end else if (paddle_hit) begin
            sq_xvel <= SCALE_VELX * hit_y + MIN_VEL;
            sq_yvel <= SCALE_VELY * hit_y;
        end
    end
    
endmodule