module LED4(input [7:0] in_data,
            input begin_flag,
            output reg [7:0] state_reg,
            output reg [3:0] out_data,
            input clock);
    
    reg [19:0] delay_cnt = 20'h00000;
    reg [7:0] buffer;

    always @(posedge clock) begin
        if(delay_cnt == 20'h00000 && begin_flag == 1'b0) begin
            delay_cnt <= 20'h00000;
            state_reg <= 8'b00000000;
            buffer <= in_data;
        end else if(delay_cnt == 20'h00000 && begin_flag == 1'b1) begin
            delay_cnt <= delay_cnt + 20'h00001;
            state_reg <= 8'b00000001;
            buffer <= in_data;
        end else if(delay_cnt != 20'h7a120) begin
            delay_cnt <= delay_cnt + 20'h00001;
            state_reg <= 8'b00000001;
            buffer <= buffer;
        end else if(delay_cnt == 20'h7a120) begin
            delay_cnt <= 20'h00000;
            state_reg <= 8'b00000001;
            out_data <= buffer[3:0];
        end
    end
endmodule
