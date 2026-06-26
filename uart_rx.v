module uart_rx
#(
    parameter CLKS_PER_BIT = 104
)
(
    input clk,
    input rst,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done
);


localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam DATA  = 3'd2;
localparam STOP  = 3'd3;
localparam DONE  = 3'd4;

// register for fsm 
reg [2:0] state;
reg [15:0] clk_count;
reg [2:0] bit_index;
reg [7:0] rx_shift;


// UART Receiver FSM
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state      <= IDLE;
        clk_count  <= 0;
        bit_index  <= 0;
        rx_shift   <= 8'd0;
        rx_data    <= 8'd0;
        rx_done    <= 1'b0;
    end
    else
    begin
        case(state)

        // Wait for Start Bit
        IDLE:
        begin
            rx_done   <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;

            if(rx == 1'b0)
                state <= START;
            else
                state <= IDLE;
        end
        
        // Verify Start Bit
        START:
        begin
            if(clk_count == (CLKS_PER_BIT-1)/2)
            begin
                if(rx == 1'b0)
                begin
                    clk_count <= 0;
                    state <= DATA;
                end
                else
                    state <= IDLE;
            end
            else
                clk_count <= clk_count + 1;
        end
        // Receive 8 Data Bits
    
        DATA:
        begin
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count + 1;
            end
            else
            begin
                clk_count <= 0;

                rx_shift[bit_index] <= rx;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        
        // Check Stop Bit
        STOP:
        begin
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count + 1;
            end
            else
            begin
                clk_count <= 0;

                if(rx == 1'b1)
                    state <= DONE;
                else
                    state <= IDLE;
            end
        end

        // Output Received Byte
        DONE:
        begin
            rx_data <= rx_shift;
            rx_done <= 1'b1;
            state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule
