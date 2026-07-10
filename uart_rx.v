module uart_rx (
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done
);

    reg [3:0] bit_index;
    reg [7:0] rx_shift;
    reg receiving;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out   <= 8'b00000000;
            rx_done    <= 1'b0;
            bit_index  <= 4'd0;
            rx_shift   <= 8'b00000000;
            receiving  <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;   // default: pulse only when a byte is fully received

            // Detect start bit and begin reception
            if (!receiving && rx == 1'b0) begin
                receiving <= 1'b1;
                bit_index <= 4'd0;
            end

            // If currently receiving, capture incoming bits
            else if (receiving) begin
                if (bit_index < 4'd8) begin
                    rx_shift[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                end
                else begin
                    // After receiving 8 data bits, store output and finish
                    data_out  <= rx_shift;
                    rx_done   <= 1'b1;
                    receiving <= 1'b0;
                    bit_index <= 4'd0;
                end
            end
        end
    end

endmodule
