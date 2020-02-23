module bin_dec_decoder(bin_in, dig_3, dig_2, dig_1);
    input [7:0] bin_in;
    output [3:0] dig_3;
    output [3:0] dig_2;
    output [3:0] dig_1;

    assign dig_1 = bin_in % 10;
    assign dig_2 = (bin_in/10) % 10;
    assign dig_3 = (bin_in/100) % 10;

endmodule

