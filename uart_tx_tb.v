`timescale 1ns / 1ps

module uart_tx_tb;

    // -----------------------------------------
    // Testbench signals
    // -----------------------------------------
    reg       clk;
    reg       rst;
    reg       tx_start;
    reg [7:0] tx_data;

    wire      tx;
    wire      tx_busy;
    wire      tx_done;


    // -----------------------------------------
    // DUT - UART Transmitter
    // -----------------------------------------
    // Simulation settings:
    // CLK_FREQ  = 10 Hz
    // BAUD_RATE = 10 baud
    //
    // Therefore:
    // CLKS_PER_BIT = 10 / 10 = 1
    //
    // So every UART bit takes only
    // ONE clock cycle in simulation.
    // -----------------------------------------

    uart_tx #(
        .CLK_FREQ(10),
        .BAUD_RATE(10)
    ) DUT (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy),
        .tx_done  (tx_done)
    );


    // -----------------------------------------
    // Clock Generation
    // Clock period = 10 ns
    // -----------------------------------------

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end


    // -----------------------------------------
    // Test Sequence
    // -----------------------------------------

    initial begin

        // Initial values
        rst      = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;


        // -------------------------------------
        // Reset
        // -------------------------------------

        #20;

        rst = 1'b0;


        // -------------------------------------
        // Send ASCII character 'A'
        //
        // ASCII A = 41 Hex
        // Binary  = 0100_0001
        // -------------------------------------

        #20;

        tx_data  = 8'h41;
        tx_start = 1'b1;


        // Start pulse
        #10;

        tx_start = 1'b0;


        // -------------------------------------
        // Wait until transmission completes
        // -------------------------------------

        wait(tx_done == 1'b1);


        // Keep waveform visible
        #5000;


        // -------------------------------------
        // End simulation
        // -------------------------------------

         $finish;

    end

endmodule