module ai_opponent (
    input clk_0,
    input rst,

    input wire [9:0] sq_xpos,       // x-coordinate of the square
    input wire [9:0] sq_ypos,       // y-coordinate of the square
    input wire sq_xveldir,          // Horizontal direction the square is travelling in

    output wire [9:0] ai_pdlypos    // AI-controlled paddle position
    );

    parameter reaction_time = 0.5;  // Time the AI takes to react to the ball coming towards it
    parameter reaction_psc = reaction_time * 25_175_000;    // Number of clock cycles to react

    

endmodule