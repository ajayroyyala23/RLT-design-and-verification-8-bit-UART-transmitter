module uart_top #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,

    // Transmit interface
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    // UART serial line
    output wire       tx,
    input  wire       rx,

    // Transmit status
    output wire       tx_busy,
    output wire       tx_done,

    // Receive interface
    output wire [7:0] rx_data,
    output wire       rx_valid,
    output wire       rx_busy
);

    // -----------------------------------------
    // UART TRANSMITTER
    // -----------------------------------------

    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) TX_UNIT (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy),
        .tx_done  (tx_done)
    );


    // -----------------------------------------
    // UART RECEIVER
    // -----------------------------------------

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) RX_UNIT (
        .clk      (clk),
        .rst      (rst),
        .rx       (rx),
        .rx_data  (rx_data),
        .rx_valid (rx_valid),
        .rx_busy  (rx_busy)
    );

endmodule