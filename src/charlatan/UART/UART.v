// clock must be 50MHz
// baud rate 115200bps, stop bit 1bit, data 8bit, no parity, no flow control

module UART(
    input wire clk,
    input wire tx_en,
    input wire rx_en,
    input wire begin_flag,
    input wire rx,
    input wire[7:0] tx_data,
    output wire tx,
    output wire[7:0] rx_data,
    output wire busy_flag,
    output wire receive_flag
);

    tx tx1(clk, tx_en, begin_flag, tx_data, tx, busy_flag);
    rx rx1(clk, rx_en, rx, rx_data, flag);
    
endmodule
