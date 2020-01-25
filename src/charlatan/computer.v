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
    wire [7:0] _mem_r_data;
    reg tx_en, rx_en;
    reg begin_flag;
    reg [7:0] tx_data;
    wire [7:0] rx_data;

    reg [7:0] uart_flag;
    wire [7:0] uart_flag2;


    instr_mem instr_mem(.addr(pc),
                        .instr(instr));

    cpu cpu(.clock(clock),
            .instr(instr),
            .pc(pc),
            .rd_data(rd_data),
            .rs_data(rs_data),
            .mem_w_en(mem_w_en),
            .mem_r_data(mem_r_data));

    always @(posedge clock) begin
        if(rs_data == 8'd255 && mem_w_en == 1) begin
            {rx_en, tx_en} <= rd_data[1:0];
        end
    end

    always @(posedge clock) begin
        if(rs_data == 8'd253 && mem_w_en == 1) begin
            tx_data <= rd_data;
        end else begin
            tx_data <= tx_data;
        end
    end

    data_mem data_mem(.addr(rs_data),
                      .w_data(rd_data),
                      .w_en(mem_w_en),
                      .r_data(_mem_r_data),
                      .clock(clock));

    assign mem_r_data = (rs_data == 8'd254) ? uart_flag2 : _mem_r_data;
    
    UART UART(.clk(clock),
              .tx_en(tx_en),
              .rx_en(rx_en),
              .begin_flag(begin_flag),
              .rx(rx),
              .tx_data(tx_data),
              .tx(tx),
              .rx_data(rx_data),
              .busy_flag(uart_flag2[0]),
              .receive_flag(uart_flag2[1]));

endmodule
