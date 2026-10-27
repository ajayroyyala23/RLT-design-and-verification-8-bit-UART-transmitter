module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

    // Number of system-clock cycles required for one UART bit
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    // FSM states
    localparam [1:0]
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11;

    reg [1:0] state;

    // Baud-rate counter
    reg [31:0] baud_counter;

    // Stores input data
    reg [7:0] data_reg;

    // Counts transmitted data bits
    reg [3:0] bit_index;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state        <= IDLE;
            baud_counter <= 0;
            data_reg     <= 8'b0;
            bit_index    <= 0;

            tx            <= 1'b1;
            tx_busy       <= 1'b0;
            tx_done       <= 1'b0;
        end

        else begin

            // tx_done is normally LOW
            tx_done <= 1'b0;

            case (state)

                // --------------------------------
                // IDLE STATE
                // --------------------------------
                IDLE: begin

                    tx        <= 1'b1;
                    tx_busy   <= 1'b0;
                    baud_counter <= 0;
                    bit_index <= 0;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1'b1;
                        state    <= START;
                    end
                end


                // --------------------------------
                // START BIT
                // --------------------------------
                START: begin

                    tx      <= 1'b0;
                    tx_busy <= 1'b1;

                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        baud_counter <= 0;
                        bit_index    <= 0;
                        state        <= DATA;
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

                    tx      <= data_reg[bit_index];
                    tx_busy <= 1'b1;

                    if (baud_counter == CLKS_PER_BIT - 1) begin

                        baud_counter <= 0;

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

                    tx      <= 1'b1;
                    tx_busy <= 1'b1;

                    if (baud_counter == CLKS_PER_BIT - 1) begin

                        baud_counter <= 0;
                        tx_busy      <= 1'b0;
                        tx_done      <= 1'b1;
                        state        <= IDLE;
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
                    tx            <= 1'b1;
                    tx_busy       <= 1'b0;
                end

            endcase
        end
    end

endmodule
