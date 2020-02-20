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
    wire busy_flag;
    reg tx_en;
    reg begin_flag;
    reg [7:0] tx_data;
    wire [7:0] rx_data;

    reg [7:0] _ret_addr;
    reg [7:0] int_vec;
    reg [7:0] int_en;

    wire int_req;

    wire reg_w_en;

    wire [7:0] ret_addr;

    instr_mem instr_mem(.addr(pc),
                        .instr(instr));

    cpu cpu(.clock(clock),
            .instr(instr),
            .pc(pc),
            .rd_data(rd_data),
            .rs_data(rs_data),
            .mem_w_en(mem_w_en),
            .mem_r_data(mem_r_data),
            .int_req(int_req),
            .int_en(int_en),
            .int_vec(int_vec),
            .reg_w_en(reg_w_en),
            .ret_addr(ret_addr));

    always @(posedge clock) begin
        if(rs_data == 8'd255 && mem_w_en == 1) begin
            tx_en <= rd_data[0];
        end
    end

    always @(posedge clock) begin
        if(rs_data == 8'd253 && mem_w_en == 1) begin
            tx_data <= rd_data;
            begin_flag = 1;
        end else begin
            tx_data <= tx_data;
            begin_flag = 0;
        end
    end

    data_mem data_mem(.addr(rs_data),
                      .w_data(rd_data),
                      .w_en(mem_w_en),
                      .r_data(_mem_r_data),
                      .clock(clock));

    assign mem_r_data = (rs_data == 8'd254) ? {7'b0, busy_flag}
                      : (rs_data == 8'd252) ? rx_data   //UART RX
                      : (rs_data == 8'd251) ? _ret_addr  //戻りアドレス
                      : (rs_data == 8'd250) ? int_vec   //割り込みベクタ
                      : _mem_r_data;


    //割り込み要求が立っている時は割り込み不許可
    always @(posedge clock) begin
        if(int_req == 1'b1) begin
            int_en <= 8'h00;
            _ret_addr <= ret_addr;
        end else if(int_req == 1'b0) begin
            int_en <= 8'h01;
            _ret_addr <= _ret_addr;
        end
    end

    always @(posedge clock) begin
        //割り込みベクタの書き込み
        if(rs_data == 8'd250 && mem_w_en == 1'b1) begin
            int_vec <= rd_data;
        end else begin
            int_vec <= int_vec;
        end
    end

    UART UART(.clk(clock),
              .tx_en(tx_en),
              .rx_en(rx_en),
              .begin_flag(begin_flag),
              .rx(rx),
              .tx_data(tx_data),
              .tx(tx),
              .rx_data(rx_data),
              .busy_flag(busy_flag),
              .receive_flag(receive_flag),
              .int_req(int_req),
              .access_addr(rs_data),
              .reg_w_en(reg_w_en));

endmodule
