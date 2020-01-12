module main_controller(opcode, reg_w_en, mem_w_en, flag_w_en, imm_en);
    input [3:0] opcode;
    output reg_w_en, mem_w_en;
    output reg_reg_mem_w_sel;
    output reg_alu_w_sel;
    output flag_w_en;
    output imm_en;
    output ih_il_sel;

    assign {reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel} = main_control(op);
    
    function [6:0] main_control(input [3:0] opcode)
        begin
            case(op)
            4'b0000: main_control = 7'b1000000;    //mov
            4'b0001: main_control = 7'b1001000;    //add
            4'b0011: main_control = 7'b1001000;    //and
            4'b0100: main_control = 7'b1001000;    //or
            4'b0101: main_control = 7'b1001000;    //not
            4'b0110: main_control = 7'b1001000;    //sll
            4'b0111: main_control = 7'b1001000;    //srl
            4'b1000: main_control = 7'b1001000;    //sra
            4'b1001: main_control = 7'b0001100;    //cmp
            4'b1100: main_control = 7'b1000011;    //ldih
            4'b1101: main_control = 7'b1000010;    //ldil
            4'b1110: main_control = 7'b1010000;    //ld
            4'b1111: main_control = 7'b01xx000;    //st
            endcase
        end
    endfunction
endmodule
