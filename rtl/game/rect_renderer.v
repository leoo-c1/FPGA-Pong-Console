module rect_renderer #(
    parameter WIDTH = 10,
    parameter HEIGHT = 10
)(
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [9:0] rect_x,
    input [9:0] rect_y,
    output is_active
);
    assign is_active = (pixel_x >= rect_x) && (pixel_x < rect_x + WIDTH) &&
                       (pixel_y >= rect_y) && (pixel_y < rect_y + HEIGHT);
endmodule