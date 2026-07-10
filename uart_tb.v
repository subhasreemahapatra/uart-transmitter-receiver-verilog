`timescale 1ns / 1ps

module uart_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire tx;
    wire tx_busy;

    // Instantiate UART Transmitter
    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation
    always #5 clk = ~clk;   // 10 ns clock period

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        tx_start = 0;
        data_in = 8'b00000000;

        // Apply reset
        #10;
        rst = 0;

        // Send first data
        #10;
        data_in = 8'b10101100;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for transmission to complete
        #120;

        // Send second data
        data_in = 8'b11010010;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait again
        #120;

        $finish;
    end

endmodule
