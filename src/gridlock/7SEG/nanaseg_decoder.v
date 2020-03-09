module nanaseg_decoder(dec_in, nanaseg_out);
    input [3:0] dec_in;
    output [6:0] nanaseg_out;

    assign nanaseg_out = decode(dec_in);

    function [6:0] decode(input [3:0] dec_in);
        begin
            case(dec_in)
                4'b0000: decode = 7'b1000000;
                4'b0001: decode = 7'b1111001;
                4'b0010: decode = 7'b0100100;
                4'b0011: decode = 7'b0110000;
                4'b0100: decode = 7'b0011001;
                4'b0101: decode = 7'b0010010;
                4'b0110: decode = 7'b0000010;
                4'b0111: decode = 7'b1111000;
                4'b1000: decode = 7'b0000000;
                4'b1001: decode = 7'b0010000;
                default: decode = 7'b1111111;
            endcase
        end
    endfunction
endmodule

