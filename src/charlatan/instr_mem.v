module instr_mem(addr, instr);
    input [7:0] addr;
    output [7:0] instr;

    reg [7:0] mem[0:255];

    assign instr = mem[addr];

    initial begin
        mem[0] = 8'hc0;
        mem[1] = 8'hd1;
        mem[2] = 8'h03;
        mem[3] = 8'hcf;
        mem[4] = 8'hdf;
        mem[5] = 8'hf3;
        mem[6] = 8'hc4;
        mem[7] = 8'hd1;
        mem[8] = 8'h03;
        mem[9] = 8'hcf;
        mem[10] = 8'hdd;
        mem[11] = 8'h07;
        mem[12] = 8'hcf;
        mem[13] = 8'hde;
        mem[14] = 8'heb;
        mem[15] = 8'hc0;
        mem[16] = 8'hd1;
        mem[17] = 8'h3b;
        mem[18] = 8'h9b;
        mem[19] = 8'hc0;
        mem[20] = 8'hdc;
        mem[21] = 8'ha3;
        mem[22] = 8'hf1;
        mem[23] = 8'hc0;
        mem[24] = 8'hd6;
        mem[25] = 8'hb3;


    /*
        mem[0] = 8'hc0;
        mem[1] = 8'hd7;
        mem[2] = 8'h03;
        mem[3] = 8'hc0;
        mem[4] = 8'hd0;
        mem[5] = 8'hf3;
        mem[6] = 8'h03;
        mem[7] = 8'hd1;
        mem[8] = 8'hf3;
        mem[9] = 8'hc0;
        mem[10] = 8'hd1;
        mem[11] = 8'h07;
        mem[12] = 8'h0b;
        mem[13] = 8'hc0;
        mem[14] = 8'hd0;
        mem[15] = 8'hef;
        mem[16] = 8'h93;
        mem[17] = 8'hc1;
        mem[18] = 8'hde;
        mem[19] = 8'ha3;
        mem[20] = 8'h16;
        mem[21] = 8'hc0; //追加
        mem[22] = 8'hd1; 
        mem[23] = 8'hf7;
        mem[24] = 8'h06;
        mem[25] = 8'heb;
        mem[26] = 8'h13;
        mem[27] = 8'hc0;
        mem[28] = 8'hdd;
        mem[29] = 8'hb3;
        mem[30] = 8'h00;
        mem[31] = 8'hc1;
        mem[32] = 8'hde;
        mem[33] = 8'hb3;
        */
    end
endmodule








