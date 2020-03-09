module nanaseg(bin_in, seg_dig1, seg_dig2, seg_dig3);
    input [7:0] bin_in;
    output [6:0] seg_dig1;
    output [6:0] seg_dig2;
    output [6:0] seg_dig3;

    wire [3:0] dig_3;
    wire [3:0] dig_2;
    wire [3:0] dig_1;

    bin_dec_decoder bin_dec_decoder(.bin_in(bin_in),
                                    .dig_3(dig_3),
                                    .dig_2(dig_2),
                                    .dig_1(dig_1));
    nanaseg_decoder seg3(.dec_in(dig_3),
                         .nanaseg_out(seg_dig3));
    nanaseg_decoder seg2(.dec_in(dig_2),
                         .nanaseg_out(seg_dig2));
    nanaseg_decoder seg1(.dec_in(dig_1),
                         .nanaseg_out(seg_dig1));
endmodule

