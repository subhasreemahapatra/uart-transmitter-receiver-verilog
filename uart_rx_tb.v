`timescale 1ns / 1ps

module uart_rx_tb;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] data_out;
    wire rx_done;

    // Instantiate UART Receiver
    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, uart_rx_tb);

        // Initialize signals
        clk = 0;
        rst = 1;
        rx  = 1'b1;   // UART line idle high

        // Apply reset
        #10;
        rst = 0;

        // -----------------------------
        // Send first byte: 8'hAC
        // UART frame = start bit + 8 data bits + stop bit
        // data 8'hAC = 10101100
        // LSB first transmission = 0 0 1 1 0 1 0 1
        // -----------------------------
        #10;
        rx = 1'b0;   // start bit
        #10; rx = 1'b0; // bit0
        #10; rx = 1'b0; // bit1
        #10; rx = 1'b1; // bit2
        #10; rx = 1'b1; // bit3
        #10; rx = 1'b0; // bit4
        #10; rx = 1'b1; // bit5
        #10; rx = 1'b0; // bit6
        #10; rx = 1'b1; // bit7
        #10; rx = 1'b1; // stop bit

        // Wait some time
        #20;

        // -----------------------------
        // Send second byte: 8'hD2
        // data 8'hD2 = 11010010
        // LSB first transmission = 0 1 0 0 1 0 1 1
        // -----------------------------
        rx = 1'b0;   // start bit
        #10; rx = 1'b0; // bit0
        #10; rx = 1'b1; // bit1
        #10; rx = 1'b0; // bit2
        #10; rx = 1'b0; // bit3
        #10; rx = 1'b1; // bit4
        #10; rx = 1'b0; // bit5
        #10; rx = 1'b1; // bit6
        #10; rx = 1'b1; // bit7
        #10; rx = 1'b1; // stop bit

        #30;
        $finish;
    end

endmodule
