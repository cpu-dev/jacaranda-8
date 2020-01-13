module test_bench();
    reg clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu);
    end

    initial begin
        clock = 1'b0;
    end

    cpu cpu(clock);

    always #1 begin
        clock = ~clock;
    end

    initial begin
        #1000
        $finish;
    end
endmodule
