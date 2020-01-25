module computer(input clock);
    wire [7:0] instr;
    wire [7:0] pc;
    wire [7:0] rd_data;
    wire [7:0] rs_data;
    wire mem_w_en;
    wire [7:0] mem_r_data;

    instr_mem instr_mem(.addr(pc),
                        .instr(instr));

    cpu cpu(.clock(clock)
            .instr(instr)
            .pc(pc)
            .rd_data(rd_data),
            .rs_data(rs_data)
            .mem_w_en(mem_w_en),
            .mem_r_data(mem_r_data));

    data_mem data_mem(.addr(rs_data),
                      .w_data(rd_data),
                      .w_en(mem_w_en),
                      .r_data(mem_r_data),
                      .clock(clock));

endmodule
