// clock must be 50MHz
// baud rate 115200bps, stop bit 1bit, data 8bit, no parity, no flow control

module UART(
    input wire clk,
    input wire tx_en,
    input wire rx_en,
    input wire begin_flag,
    input wire rx,
    output wire tx,
    output wire busy_flag,
    output wire receive_flag
);

    wire[7:0] data;

    tx tx1(clk, tx_en, begin_flag, data, tx, busy_flag);
    rx rx1(clk, rx_en, rx, data, flag);
    
endmodule
