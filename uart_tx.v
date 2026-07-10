module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,
    output reg tx,
    output reg tx_busy
);

    reg [3:0] bit_index;
    reg [9:0] tx_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;         
            tx_busy <= 1'b0;
            bit_index <= 4'd0;
            tx_data <= 10'b1111111111;
        end
        else begin
            if (tx_start && !tx_busy) begin
                tx_data <= {1'b1, data_in, 1'b0};
                tx_busy <= 1'b1;
                bit_index <= 4'd0;
            end
            else if (tx_busy) begin
                tx <= tx_data[bit_index];

                if (bit_index == 4'd9) begin
                    tx_busy <= 1'b0;
                    bit_index <= 4'd0;
                    tx <= 1'b1;
                end
                else begin
                    bit_index <= bit_index + 1;
                end
            end
        end
    end

endmodule
