module main_controller(opcode, reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel, jmp_en, je_en);
    input [3:0] opcode;
    output reg_w_en, mem_w_en;
    output reg_reg_mem_w_sel;
    output reg_alu_w_sel;
    output flag_w_en;
    output imm_en;
    output ih_il_sel;
    output jmp_en, je_en;

    assign {reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel, jmp_en, je_en} = main_control(opcode);
    
    function [8:0] main_control(input [3:0] opcode);
        begin
            case(opcode)
            4'b0000: main_control = 9'b100000000;    //mov
            4'b0001: main_control = 9'b100100000;    //add
            4'b0011: main_control = 9'b100100000;    //and
            4'b0100: main_control = 9'b100100000;    //or
            4'b0101: main_control = 9'b100100000;    //not
            4'b0110: main_control = 9'b100100000;    //sll
            4'b0111: main_control = 9'b100100000;    //srl
            4'b1000: main_control = 9'b100100000;    //sra
            4'b1001: main_control = 9'b000110000;    //cmp
            4'b1010: main_control = 9'b000000001;    //je
            4'b1011: main_control = 9'b000000010;    //jmp
            4'b1100: main_control = 9'b100001100;    //ldih
            4'b1101: main_control = 9'b100001000;    //ldil
            4'b1110: main_control = 9'b101000000;    //ld
            4'b1111: main_control = 9'b010000000;    //st
            endcase
        end
    endfunction
endmodule
