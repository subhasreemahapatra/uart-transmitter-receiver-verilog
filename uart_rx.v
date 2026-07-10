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
            data_out  <= 8'b00000000;
            rx_done   <= 1'b0;
            bit_index <= 4'd0;
            rx_shift  <= 8'b00000000;
            receiving <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;   // default: pulse only for 1 cycle when byte received

            // Start bit detection
            if (!receiving && rx == 1'b0) begin
                receiving <= 1'b1;
                bit_index <= 4'd0;
            end

            // Receive 8 data bits
            else if (receiving) begin
                rx_shift[bit_index] <= rx;

                if (bit_index == 4'd7) begin
                    data_out  <= {rx, rx_shift[6:0]};
                    rx_done   <= 1'b1;
                    receiving <= 1'b0;
                    bit_index <= 4'd0;
                end
                else begin
                    bit_index <= bit_index + 1;
                end
            end
        end
    end

endmodule
