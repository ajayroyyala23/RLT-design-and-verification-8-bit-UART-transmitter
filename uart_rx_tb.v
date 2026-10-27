`timescale 1ns / 1ps

module uart_rx_tb;

    // -----------------------------------------
    // Testbench signals
    // -----------------------------------------

    reg       clk;
    reg       rst;
    reg       rx;

    wire [7:0] rx_data;
    wire       rx_valid;
    wire       rx_busy;


    // -----------------------------------------
    // UART Receiver DUT
    // -----------------------------------------
    //
    // Simulation:
    // CLK_FREQ  = 100
    // BAUD_RATE = 10
    //
    // CLKS_PER_BIT = 10
    //
    // Clock period = 10 ns
    // UART bit time = 100 ns
    // -----------------------------------------

    uart_rx #(
        .CLK_FREQ(100),
        .BAUD_RATE(10)
    ) DUT (
        .clk      (clk),
        .rst      (rst),
        .rx       (rx),
        .rx_data  (rx_data),
        .rx_valid (rx_valid),
        .rx_busy  (rx_busy)
    );


    // -----------------------------------------
    // Clock generation
    // 10 ns clock period
    // -----------------------------------------

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end


    // -----------------------------------------
    // UART frame transmission task
    // Sends:
    //
    // START = 0
    // DATA  = LSB first
    // STOP  = 1
    // -----------------------------------------

    task send_byte;
        input [7:0] data;
        integer i;

        begin

            // -----------------------------
            // Start bit
            // -----------------------------
            rx = 1'b0;
            #100;


            // -----------------------------
            // 8 data bits - LSB first
            // -----------------------------
            for (i = 0; i < 8; i = i + 1) begin

                rx = data[i];
                #100;

            end


            // -----------------------------
            // Stop bit
            // -----------------------------
            rx = 1'b1;
            #100;

        end
    endtask


    // -----------------------------------------
    // Test sequence
    // -----------------------------------------

    initial begin

        // Initial values
        rst = 1'b1;
        rx  = 1'b1;


        // -----------------------------
        // Reset
        // -----------------------------

        #20;

        rst = 1'b0;


        // -----------------------------
        // Wait before transmission
        // -----------------------------

        #100;


        // -----------------------------
        // Send ASCII 'A'
        //
        // A = 0x41
        // -----------------------------

        send_byte(8'h41);


        // -----------------------------
        // Wait
        // -----------------------------

        #200;


        // -----------------------------
        // End simulation
        // -----------------------------

        $finish;

    end

endmodule