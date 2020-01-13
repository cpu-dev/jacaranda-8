module decoder(instr, opcode, rs_a, rd_a, imm);
    input [7:0] instr;
    output [3:0] opcode;
    output [1:0] rs_a, rd_a;
    output [3:0] imm;

    assign opcode = instr[7:4];
    assign rd_a = instr[3:2];
    assign rs_a = instr[1:0];
    assign imm = instr[3:0];
endmodule
