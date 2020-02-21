module main_controller(opcode, rd_a, reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel, jmp_en, je_en, ret);
    input [3:0] opcode;
    input [1:0] rd_a;
    output reg_w_en, mem_w_en;
    output reg_reg_mem_w_sel;
    output reg_alu_w_sel;
    output flag_w_en;
    output imm_en;
    output ih_il_sel;
    output jmp_en, je_en;
    output ret;

    assign {reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel, jmp_en, je_en, ret} = main_control(opcode, rd_a);
    
    function [9:0] main_control(input [3:0] opcode, input [1:0] rd_a);
        begin
            case(opcode)
            4'b0000: main_control = 10'b1000000000;    //mov
            4'b0001: main_control = 10'b1001000000;    //add
            4'b0011: main_control = 10'b1001000000;    //and
            4'b0100: main_control = 10'b1001000000;    //or
            4'b0101: main_control = 10'b1001000000;    //not
            4'b0110: main_control = 10'b1001000000;    //sll
            4'b0111: main_control = 10'b1001000000;    //srl
            4'b1000: main_control = 10'b1001000000;    //sra
            4'b1001: main_control = 10'b0001100000;    //cmp
            4'b1010: main_control = 10'b0000000010;    //je
            4'b1011: begin
                case(rd_a)
                    2'b01:   main_control = 10'b0000000001; //iret
                    default: main_control = 10'b0000000100; //jmp
                endcase
            end
            4'b1100: main_control = 10'b1000011000;    //ldih
            4'b1101: main_control = 10'b1000010000;    //ldil
            4'b1110: main_control = 10'b1010000000;    //ld
            4'b1111: main_control = 10'b0100000000;    //st
            endcase
        end
    endfunction
endmodule
