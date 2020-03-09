module alu_controller(opcode, alu_ctrl);
    input [3:0] opcode;
    output [3:0] alu_ctrl;

    assign alu_ctrl = alu_control(opcode);

    function [3:0] alu_control(input [3:0] opcode);
        begin
            case(opcode)
                4'b0001: alu_control = 4'b0000;
                4'b0011: alu_control = 4'b0001;
                4'b0100: alu_control = 4'b0010;
                4'b0101: alu_control = 4'b0011;
                4'b0110: alu_control = 4'b0100;
                4'b0111: alu_control = 4'b0101;
                4'b1000: alu_control = 4'b0110;
                4'b1001: alu_control = 4'b0111;
            endcase
        end
    endfunction
endmodule
