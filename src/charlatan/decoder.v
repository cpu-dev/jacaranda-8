module decoder(instr, opcode, rs_a, rd_a, imm);
    input [7:0] instr;
    output [3:0] opcode;
    output [1:0] rs_addr, rd_addr;
    output [3:0] imm;

    assign opcode = instr[7:4];
    assign rd_addr = instr[3:2];
    assign rs_addr = instr[1:0];
    assign imm = instr[3:0];
endmodule
