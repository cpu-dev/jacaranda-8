module LED4(input [7:0] led_in_data,
            output reg [3:0] led_out_data,
            input clock);
    
    always @(posedge clock) begin
        led_out_data <= led_in_data[3:0];
    end
endmodule
