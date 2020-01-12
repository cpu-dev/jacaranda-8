module instr_mem(addr, instr);
    input [7:0] addr;
    output [7:0] instr;

    reg [7:0] mem[256];

    assign instr = mem[addr];
endmodule
