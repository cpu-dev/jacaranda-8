module LED4(input [7:0] in_data,
            input begin_flag,
            output reg [7:0] state_reg,
            output reg [3:0] out_data,
            input clock);
    
    reg [27:0] delay_cnt = 28'h0000000;
    reg [7:0] buffer;

    always @(posedge clock) begin
        if(delay_cnt == 28'h0000000 && begin_flag == 1'b0) begin
            delay_cnt <= 28'h0000000;
            state_reg <= 8'b00000000;
            buffer <= in_data;
        end else if(delay_cnt == 28'h0000000 && begin_flag == 1'b1) begin
            delay_cnt <= delay_cnt + 28'h0000001;
            state_reg <= 8'b00000001;
            buffer <= in_data;
        end else if(delay_cnt != 28'h2faf080) begin
            delay_cnt <= delay_cnt + 28'h0000001;
            state_reg <= 8'b00000001;
            buffer <= buffer;
        end else if(delay_cnt == 28'h2faf080) begin
            delay_cnt <= 28'h0000000;
            state_reg <= 8'b00000001;
            out_data <= buffer[3:0];
        end
    end
endmodule
