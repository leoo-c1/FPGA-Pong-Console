module button_debouncer #(
    parameter BUTTONS = 4,                  // Number of buttons to debounce
    parameter DEBOUNCE_LIMIT = 1_000_000    // 20ms at 50MHz
)(
    input  clk,                             // 50MHz clock
    input  rst,                             // Reset button (Active Low)
    input  [BUTTONS-1:0] raw_signal,        // Raw button signals
    output [BUTTONS-1:0] debounced_signal   // Debounced button signals
);

    genvar i;
    generate
        for (i = 0; i < BUTTONS; i = i + 1) begin : bounce_logic
            
            reg sync_0, sync_1;     // Sync chain to prevent metastability
            reg [19:0] counter;     // Debounce timer
            reg clean_out;          // Internal clean signal

            always @(posedge clk) begin
                if (!rst) begin
                    sync_0 <= 0;
                    sync_1 <= 0;
                    counter <= 0;
                    clean_out <= 0;
                end else begin
                    // Sync the input
                    sync_0 <= raw_signal[i];
                    sync_1 <= sync_0;

                    // If input doesn't match output, start counting
                    if (sync_1 != clean_out) begin
                        counter <= counter + 1;
                        
                        // If stable for enough time, update the output
                        if (counter == DEBOUNCE_LIMIT) begin
                            clean_out <= sync_1;
                            counter <= 0;
                        end
                    end else begin
                        counter <= 0;   // Reset if signal changes
                    end
                end
            end

            assign debounced_signal[i] = clean_out;

        end
    endgenerate

endmodule