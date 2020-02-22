module LED4(input [7:0] led_in_data,
            output reg [3:0] led_out_data = 4'b0000,
            input clock);
    
    always @(posedge clock) begin
        led_out_data <= led_in_data[3:0];
    end
endmodule
