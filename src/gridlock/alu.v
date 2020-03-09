module alu(rd, rs, alu_ctrl, alu_out);
    input [7:0] rd, rs;
    input [3:0] alu_ctrl;
    output [7:0] alu_out;

    assign alu_out = execute(rd, rs, alu_ctrl);

    function [7:0] execute(input [7:0] rd, input [7:0] rs, input [3:0] alu_ctrl);
        begin
            case(alu_ctrl)
            4'b0000: execute = rd + rs;
            4'b0001: execute = rd & rs;
            4'b0010: execute = rd | rs;
            4'b0011: execute = ~rs;
            4'b0100: execute = rd << rs;
            4'b0101: execute = rd >> rs;
            4'b0110: execute = $signed(rd) >>> $signed(rs);
            4'b0111: execute = (rd == rs);
            default: execute = 8'b0000_0000;
            endcase
        end
    endfunction
endmodule
