module net_renderer #(
    parameter H_VIDEO = 640,
    parameter NET_WIDTH = 6,
    parameter DASH_HEIGHT = 12,  // Height of the white part
    parameter GAP_HEIGHT = 12    // Height of the empty part
)(
    input clk,
    input rst,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg pixel_on
);

    localparam TOTAL_PERIOD = DASH_HEIGHT + GAP_HEIGHT;
    reg [5:0] line_counter; // Tracks vertical position in the dash pattern

    always @(posedge clk) begin
        if (!rst) begin
            pixel_on <= 0;
            line_counter <= 18; // Start offset
        end else if (video_on) begin
            
            // Check if we are in the center column
            if (pixel_x >= (H_VIDEO/2 - NET_WIDTH/2) && 
                pixel_x <= (H_VIDEO/2 + NET_WIDTH/2 - 1)) begin
                
                // Check if we are in the dash part
                if (line_counter < DASH_HEIGHT) begin
                    pixel_on <= 1'b1;
                end else begin
                    pixel_on <= 1'b0;
                end
            end else begin
                pixel_on <= 1'b0;
            end

            // Update counter at the start of every line
            if (pixel_x == 0) begin
                if (pixel_y == 0) begin
                    // Reset at top of screen to keep pattern static
                    line_counter <= 18; 
                end else begin
                    // Increment and wrap around
                    if (line_counter >= TOTAL_PERIOD - 1) begin
                        line_counter <= 0;
                    end else begin
                        line_counter <= line_counter + 1;
                    end
                end
            end
        end else begin
            pixel_on <= 0;
        end
    end

endmodule