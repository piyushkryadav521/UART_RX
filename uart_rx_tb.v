`timescale 1ns/1ps

module uart_rx_tb;

    parameter CLKS_PER_BIT = 8;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] rx_data;
    wire rx_done;

    // Instantiate UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock Generation
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;      // 10 ns clock period
    end

    
    task send_byte;
        input [7:0] data;
        integer i;
        begin

            // Idle
            rx = 1'b1;
            #(CLKS_PER_BIT*10);

            // Start Bit
            rx = 1'b0;
            #(CLKS_PER_BIT*10);

            // Data Bits (LSB First)
            for(i=0;i<8;i=i+1)
            begin
                rx = data[i];
                #(CLKS_PER_BIT*10);
            end

            // Stop Bit
            rx = 1'b1;
            #(CLKS_PER_BIT*10);

        end
    endtask

    initial begin

        $dumpfile("uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);

        rst = 1;
        rx  = 1;

        #20;
        rst = 0;

        // Send 0xA5
        send_byte(8'hA5);

        #200;

        $finish;

    end

    initial begin
        $monitor("Time=%0t RX=%b Data=%h Done=%b",
                 $time, rx, rx_data, rx_done);
    end

endmodule