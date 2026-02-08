module start_menu #(
    parameter KERNING = 0,
    parameter TITLE_SCALE = 10,
    parameter SELECT_SCALE = 5,
    parameter MODE_SCALE = 3,
    // Coordinates for top left of the 'P' in 'PONG' so the word is centered
    parameter TITLE_X = 320 - 3*KERNING/2 - 12*TITLE_SCALE,
    parameter TITLE_Y = 60,
    // Coordinates for top left of the 'S' in 'SELECT MODE:'
    parameter SELECT_X = 320 - 6*6*SELECT_SCALE - 5*KERNING,
    parameter SELECT_Y = TITLE_Y + 8*TITLE_SCALE + 60 - 1,
    // Coordinates for top left of the 'S' in 'SINGLEPLAYER'
    parameter SP_X = 320 - 6*6*MODE_SCALE - 5*KERNING,
    parameter SP_Y = SELECT_Y + 8*SELECT_SCALE + 20 - 1,
    // Coordinates for top left of the 'M' in 'MULTIPLAYER'
    parameter MP_X = 320 - 33*MODE_SCALE - 4*KERNING,
    parameter MP_Y = SP_Y + 8*MODE_SCALE + 20 - 1,
    // x-coordinate for the top left of the '>' mode choice indicator
    parameter CHOICE_X = SP_X - 6*MODE_SCALE - KERNING - 20

    ) (
    input clk_0,
    input rst,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,

    input wire up,                  // Selects '1 PLAYER'
    input wire down,                // Selects '2 PLAYERS'
    input wire start_trigger,       // If we receive the 'any key' input to lock in mode and start
    
    output wire in_text,            // Whether or not current pixel is inside a menu string
    output reg [1:0] mode_choice    // Gamemode choice, 0 = nothing, 1 = 1 player, 2 = 2 players
    );

    reg [8:0] choice_y = SP_Y;
    wire in_choice;

    // Create text for start menu
    startup_text startup_text_display (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .in_text(in_startup_text)
    );

    // Generate '>' to indicate mode selection
    string_display #(
        .SCALE(MODE_SCALE),
        .KERNING(KERNING),
        .LEN(1),
        .TEXT(">")
    ) choice (
        .clk_0(clk_0),
        .rst(rst),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .x_pos(CHOICE_X), .y_pos(choice_y),
        .pixel_on(in_choice)
    );

    assign in_text = (in_startup_text | in_choice);

    always @ (posedge clk_0) begin
        if (!rst) begin             // If the reset button is pressed
        // No choice is made, hover over the default singleplayer choice
        mode_choice <= 2'b00;
        choice_y <= SP_Y;
        end else begin
            if (up)
                choice_y <= SP_Y;
            else if (down)
                choice_y <= MP_Y;

            // Lock in the current mode selection when user presses a key to start
            if (start_trigger) begin
                if (choice_y == SP_Y)       // If singleplayer is chosen
                    mode_choice <= 2'b01;
                else if (choice_y == MP_Y)  // If multiplayer is chosen
                    mode_choice <= 2'b10;
            end

        end
    end

endmodule