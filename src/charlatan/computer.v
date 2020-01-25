module computer(
    input clock,
    input rx,
    output tx
);
    wire [7:0] instr;
    wire [7:0] pc;
    wire [7:0] rd_data;
    wire [7:0] rs_data;
    wire mem_w_en;
    wire [7:0] mem_r_data;
    wire tx_en, rx_en;
    reg begin_flag;
    reg busy_flag;
    wire receive_flag;
    reg [7:0] tx_data;
    wire [7:0] rx_data;

    reg [7:0] uart_flag;

    instr_mem instr_mem(.addr(pc),
                        .instr(instr));

    cpu cpu(.clock(clock),
            .instr(instr),
            .pc(pc),
            .rd_data(rd_data),
            .rs_data(rs_data),
            .mem_w_en(mem_w_en),
            .mem_r_data(mem_r_data));

    data_mem data_mem(.addr(rs_data),
                      .w_data(rd_data),
                      .w_en(mem_w_en),
                      .r_data(mem_r_data),
                      .clock(clock));
    
    UART UART(.clk(clock),
              .tx_en(tx_en),
              .rx_en(rx_en),
              .begin_flag(begin_flag),
              .rx(rx),
              .tx_data(tx_data),
              .tx(tx),
              .rx_data(rx_data),
              .busy_flag(busy_flag),
              .receive_flag(receive_flag));

endmodule
