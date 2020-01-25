module test_bench();
    reg clock;
    wire rx, tx;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, computer);
    end

    initial begin
        clock = 1'b0;
    end

    computer computer(clock, rx, tx);

    always #1 begin
        clock = ~clock;
    end

    initial begin
        #1000
        $finish;
    end
endmodule
