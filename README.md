RTL Design and Verification of an 8-bit UART Transmitter using Verilog HDL

1. Project Overview

This project focuses on the RTL design and verification of an 8-bit UART (Universal Asynchronous Receiver Transmitter) Transmitter using Verilog HDL. It converts 8-bit parallel data into serial data using the UART 8-N-1 communication protocol.

The design uses Finite State Machine (FSM)-based control logic and a configurable baud rate generator. The functionality is verified through Verilog testbenches and waveform analysis using Xilinx Vivado.

2. Objectives

- To design an 8-bit UART transmitter using Verilog HDL.
- To implement UART 8-N-1 serial communication.
- To develop FSM-based control logic.
- To support configurable baud rates.
- To verify the design using simulation and testbenches.
- To implement the design on an FPGA board.

3. System Architecture

The UART transmitter consists of the following main blocks:

1. Baud Rate Generator
2. Data Register
3. Finite State Machine (FSM)
4. Bit Counter
5. Serial Transmitter Output

Data Flow:

Parallel Data → Data Register → FSM Control → Serial Output (TX)

4. UART Communication Protocol

The project uses the UART 8-N-1 communication format.

- Start Bit: 1 bit (Logic 0)
- Data Bits: 8 bits
- Parity Bit: No parity
- Stop Bit: 1 bit (Logic 1)

Data is transmitted in Least Significant Bit (LSB) first order.

5. Technologies Used

- Hardware Description Language: Verilog HDL
- Design Tool: Xilinx Vivado
- Simulation: Vivado Simulator
- FPGA Board: Digilent Arty S7-25
- FPGA Device: Spartan-7

6. Project Files

The repository contains the following Verilog source files and supporting design files:

- "uart_tx.v" – UART transmitter module.
- "uart_tx_tb.v" – UART transmitter testbench.
- "uart_rx.v" – UART receiver module.
- "uart_rx_tb.v" – UART receiver testbench.
- "uart_top.v" – Top-level module.
- "uart_top_tb.v" – Top-level testbench.
- "URAT_8BIT_TX.v" – Additional project Verilog source file.
- "uart_top.dcp" – Design checkpoint file.
- "uart_vlsi.lpr" – Project-related file.

7. Verification and Test Cases

The UART transmitter is verified using different input data patterns.

Test Case 1 – All Zeros

Input Data: "00000000"

Checks the transmission of all-zero data.

Test Case 2 – All Ones

Input Data: "11111111"

Checks the transmission of all-one data.

Test Case 3 – Alternating Bits

Input Data: "10101010"

Checks the correct transmission of alternating data bits.

8. FPGA Implementation

The design is implemented on the Digilent Arty S7-25 FPGA development board using Xilinx Vivado.

The implementation process includes:

- RTL Synthesis
- Design Implementation
- Placement and Routing
- Timing Analysis
- Bitstream Generation

9. Resource Utilization

Resource| Utilization
LUTs| 82
Registers| 118
BRAM| 0
DSP48| 0
I/O Buffers| 6

10. Expected Outcome

The UART transmitter converts parallel 8-bit data into serial data according to the UART 8-N-1 protocol. Simulation and FPGA implementation are used to verify the design functionality and timing behavior.

11. Conclusion

This project demonstrates the RTL design and verification of an 8-bit UART transmitter using Verilog HDL. It provides practical knowledge of serial communication, FSM-based design, digital verification, FPGA implementation, and timing analysis.

12. Author

Ajay Royyala

Electronics and Communication Engineering (ECE)

Malla Reddy University

Project: RTL Design and Verification of an 8-bit UART Transmitter using Verilog HDL
