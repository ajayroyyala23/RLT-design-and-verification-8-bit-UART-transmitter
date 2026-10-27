module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,

    output reg [7:0]  rx_data,
    output reg        rx_valid,
    output reg        rx_busy
);
    // Number of clock cycles per UART bit
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    // UART states
    localparam [2:0]
        IDLE  = 3'b000,
        START = 3'b001,
        DATA  = 3'b010,
        STOP  = 3'b011;

    reg [2:0] state;

    // Baud counter
    reg [31:0] baud_counter;

    // Data bit counter
    reg [3:0] bit_index;

    // Received data register
    reg [7:0] data_reg;


    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state        <= IDLE;
            baud_counter <= 0;
            bit_index    <= 0;
            data_reg     <= 8'b0;

            rx_data      <= 8'b0;
            rx_valid     <= 1'b0;
            rx_busy      <= 1'b0;

        end

        else begin

            // rx_valid is normally LOW
            rx_valid <= 1'b0;

            case (state)

                // --------------------------------
                // IDLE
                // --------------------------------
                IDLE: begin

                    rx_busy      <= 1'b0;
                    baud_counter <= 0;
                    bit_index    <= 0;

                    // UART start bit is LOW
                    if (rx == 1'b0) begin

                        rx_busy      <= 1'b1;
                        baud_counter <= 0;
                        state        <= START;

                    end

                end


                // --------------------------------
                // START BIT
                // --------------------------------
                START: begin

                    rx_busy <= 1'b1;

                    // Wait until middle of start bit
                    if (baud_counter == (CLKS_PER_BIT / 2) - 1) begin

                        baud_counter <= 0;

                        // Confirm start bit is still LOW
                        if (rx == 1'b0) begin
                            state <= DATA;
                            bit_index <= 0;
                        end
                        else begin
                            state <= IDLE;
                            rx_busy <= 1'b0;
                        end

                    end

                    else begin
                        baud_counter <= baud_counter + 1;
                    end

                end


                // --------------------------------
                // DATA BITS
                // LSB FIRST
                // --------------------------------
                DATA: begin

                    rx_busy <= 1'b1;

                    if (baud_counter == CLKS_PER_BIT - 1) begin

                        baud_counter <= 0;

                        // Store received bit
                        data_reg[bit_index] <= rx;

                        if (bit_index == 7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1;
                        end

                    end

                    else begin
                        baud_counter <= baud_counter + 1;
                    end

                end


                // --------------------------------
                // STOP BIT
                // --------------------------------
                STOP: begin

                    rx_busy <= 1'b1;

                    if (baud_counter == CLKS_PER_BIT - 1) begin

                        baud_counter <= 0;

                        // Copy received byte to output
                        rx_data <= data_reg;

                        rx_valid <= 1'b1;
                        rx_busy  <= 1'b0;

                        state <= IDLE;

                    end

                    else begin
                        baud_counter <= baud_counter + 1;
                    end

                end


                // --------------------------------
                // DEFAULT
                // --------------------------------
                default: begin

                    state        <= IDLE;
                    baud_counter <= 0;
                    bit_index    <= 0;
                    rx_busy      <= 1'b0;

                end

            endcase

        end

    end

endmodule