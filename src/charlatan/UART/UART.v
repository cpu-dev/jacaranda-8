// clock must be 50MHz
// baud rate 115200bps, stop bit 1bit, data 8bit, no parity, no flow control

module UART(
    input wire clk,
    input wire tx_en,
    input wire rx_en,
    input wire begin_flag,
    input wire rx,
    input wire [7:0] tx_data,
    input wire [7:0] access_addr,
    input wire reg_w_en,
    output wire tx,
    output wire[7:0] rx_data,
    output wire busy_flag,
    output wire receive_flag,
    output reg int_req = 1'b0
);

    reg state = 1'b0;
    wire end_flag;

    always @(posedge clk) begin
        if(state == 1'b0) begin //データ待機中
            int_req <= 1'b0;
            if(end_flag == 1'b1) begin
                state <= 1'b1;
            end else begin
                state <= state;
            end
        end else if(state == 1'b1) begin //データが来たことをCPUに伝える
            int_req <= 1'b1;
            if(access_addr == 8'd252 && reg_w_en == 1'b1) begin
                state <= 1'b0;
            end else begin
                state <= state;
            end
        end
    end

    tx tx1(clk, tx_en, begin_flag, tx_data, tx, busy_flag);
    rx rx1(clk, rx_en, rx, rx_data, receive_flag);
    
endmodule
