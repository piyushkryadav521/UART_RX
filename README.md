# UART Receiver using Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) Receiver using Verilog HDL. The receiver converts serial data received on the UART RX line into an 8-bit parallel output. The design is based on a Finite State Machine (FSM) and includes start bit detection, data reception, stop bit verification, and data valid indication.



# Objective

* Design a UART Receiver using Verilog HDL.
* Receive serial data and convert it into 8-bit parallel data.
* Verify the design using a Verilog testbench.
* Simulate the design using Icarus Verilog.
* Analyze the waveform using GTKWave.
* Synthesize the RTL using Quartus Prime.



# Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Quartus Prime



# UART Frame Format

A standard UART frame consists of:

| Field     | Bits |
| --------- | ---- |
| Idle      | 1    |
| Start Bit | 1    |
| Data Bits | 8    |
| Stop Bit  | 1    |

Example UART Frame:


Idle  Start   D0 D1 D2 D3 D4 D5 D6 D7   Stop
  1      0     1  0  1  0  0  1  0  1     1


The UART Receiver samples the incoming serial data and reconstructs the original 8-bit data.


# Features

* Asynchronous serial communication
* 8-bit data reception
* Start bit detection
* Stop bit verification
* Data valid (`rx_done`) indication
* Parameterized clocks per bit (`CLKS_PER_BIT`)
* FSM-based implementation



# Module Description

### Inputs

| Signal | Description        |
| ------ | ------------------ |
| clk    | System clock       |
| rst    | Asynchronous reset |
| rx     | Serial UART input  |

### Outputs

| Signal       | Description                         |
| ------------ | ----------------------------------- |
| rx_data[7:0] | Received parallel data              |
| rx_done      | Indicates successful data reception |



# Internal Registers

| Register  | Purpose                  |
| --------- | ------------------------ |
| state     | Current FSM state        |
| clk_count | Baud clock counter       |
| bit_index | Counts received bits     |
| rx_shift  | Temporary shift register |



# FSM States

The UART Receiver is implemented using the following states:


           +------+
           | IDLE |
           +------+
               |
        Start Bit Detected
               |
               ▼
          +---------+
          | START   |
          +---------+
               |
               ▼
          +---------+
          |  DATA   |
          +---------+
               |
        8 Bits Received
               |
               ▼
          +---------+
          |  STOP   |
          +---------+
               |
               ▼
          +---------+
          |  DONE   |
          +---------+
               |
               ▼
             IDLE




# Working Principle

1. Wait for the RX line to go LOW (Start Bit).
2. Wait until the middle of the start bit.
3. Receive 8 serial data bits (LSB first).
4. Store each received bit into a shift register.
5. Verify that the stop bit is HIGH.
6. Transfer the received byte to `rx_data`.
7. Assert `rx_done` for one clock cycle.



# Simulation

### Compile

bash
iverilog -o uart_sim uart_rx.v uart_rx_tb.v


### Run

bash
vvp uart_sim


### Open Waveform

bash
gtkwave uart_rx.vcd




# Expected Results

The receiver should:

* Detect the start bit.
* Receive all 8 data bits correctly.
* Verify the stop bit.
* Output the received byte on `rx_data`.
* Assert `rx_done` after successful reception.

Example:


Received Data = 8'hA5
rx_done = 1




# Applications

* FPGA communication interfaces
* Microcontroller communication
* Embedded systems
* Serial communication modules
* IoT devices
* Industrial automation systems



# Learning Outcomes

This project demonstrates:

* UART communication protocol
* Finite State Machine (FSM) design
* Shift register implementation
* Bit counter implementation
* Baud rate timing control
* Serial-to-parallel data conversion
* RTL design using Verilog HDL
* Testbench development
* Functional simulation
* Waveform debugging
* RTL synthesis



# Future Improvements

* Configurable baud rates
* UART Transmitter implementation
* Parity bit generation and checking
* Framing error detection
* Oversampling for improved reliability
* FIFO buffering
* Full UART Transceiver (TX + RX)



# Author

**Piyush Kumar Yadav**

Aspiring Digital VLSI / RTL Design Engineer

---

# Conclusion

The UART Receiver was successfully designed, simulated, and verified using Verilog HDL. The design correctly detects the start bit, receives serial data, validates the stop bit, and outputs the corresponding 8-bit parallel data. This project provides a strong foundation for understanding UART communication and FSM-based RTL design, making it a valuable addition to a Digital VLSI engineering portfolio.
