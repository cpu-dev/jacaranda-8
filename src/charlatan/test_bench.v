`timescale 1ns/1ps
module test_bench();
parameter TIMESCALE_HZ = 1000_000_000;
parameter CLOCK_HZ = 50_000_000;
parameter BAUD_RATE = 115200;
parameter TIME_CLOCK = $floor(TIMESCALE_HZ / CLOCK_HZ);
parameter TIME_BIT = $floor(TIMESCALE_HZ / BAUD_RATE);
    reg clk;
    reg rx;
    wire[7:0] data;
    wire end_flag;
    computer cmptr(clk, rx, tx);

always #(TIME_CLOCK/2) clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, cmptr);
    clk = 1'b0;
    rx = 1'b1;
    #1000
    #(2*TIME_BIT);
    rx = 1'b0;
    #(TIME_BIT);
    rx = 1'b0;
    #(TIME_BIT);
    rx = 1'b1;
    #(TIME_BIT);
    rx = 1'b0;
    #(TIME_BIT);
    rx = 1'b1;
    #(TIME_BIT);
    rx = 1'b0;
    #(TIME_BIT);
    rx = 1'b1;
    #(TIME_BIT);
    rx = 1'b0;
    #(TIME_BIT);
    rx = 1'b1;
    #(TIME_BIT);
    rx= 1'b1;
    #(2*TIME_BIT);
    #10000
    #80000
    $finish;
end
endmodule
