module rx(clk, rx_en, rx, data, end_flag);
    input wire clk;
    input wire rx_en;
    input wire rx;
    output reg[7:0] data = 8'b00000000;
    output reg end_flag = 1'b0;

    parameter CLK_FREQ = 50_000_000;
    parameter BAUD_RATE = 115200;
    parameter CLK_COUNT_BIT = CLK_FREQ / BAUD_RATE;
    parameter CLK_BEGIN_TO_RECEIVE = CLK_COUNT_BIT + CLK_COUNT_BIT / 2 - 4;
    
    reg[1:0] state = 2'b00;
    reg[31:0] clk_count = 32'd0;
    reg[2:0] bit_count = 3'd0;
    reg[3:0] recent = 4'b1111;
    wire update_flag;

    assign update_flag = (state == 2'b01) 
        ? clk_count == CLK_BEGIN_TO_RECEIVE 
        : clk_count == CLK_COUNT_BIT - 32'd1;
    
    always @(posedge clk) begin
        case(state)
            2'b00: begin
                clk_count <= 32'd0;
                bit_count <= 3'd0;
                end_flag <= 1'b0;
                recent = {recent[2:0], rx};
                state = (recent == 4'b0000) & rx_en ? 2'b01 : state;
            end
            2'b01: begin
                clk_count <= clk_count + 32'd1;
                if(update_flag) begin
                    state = 2'b11;
                    clk_count <= 32'd0;
                    data[2'd0] <= rx;
                    bit_count <= 3'd1;
                end
            end
            2'b11: begin
                clk_count <= clk_count + 32'd1;
                if(update_flag) begin
                    state <= (bit_count == 3'd7) ? 2'b10 : state;
                    data[bit_count] <= rx;
                    bit_count <= bit_count + 3'd1;
               clk_count <= 32'd0;
                end
            end
            2'b10: begin
                end_flag <= 1'b1;
                clk_count <= clk_count + 32'd1;
                state <= update_flag ? 2'b00 : state;
            end
        endcase
    end
endmodule
