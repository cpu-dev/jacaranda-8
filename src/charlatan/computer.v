module computer(
    input clock,
    input rx,
    output tx,
    output [3:0] led_out_data,
    output [6:0] seg_out_1,
    output [6:0] seg_out_2,
    output [6:0] seg_out_3
);
    wire [7:0] instr;
    wire [7:0] pc;
    wire [7:0] rd_data;
    wire [7:0] rs_data;
    wire mem_w_en;
    wire [7:0] mem_r_data;
    wire [7:0] _mem_r_data;
    wire busy_flag;
    wire receive_flag;
    reg tx_en;
    reg rx_en;
    reg begin_flag;
    reg [7:0] tx_data;
    wire [7:0] rx_data;

    reg [7:0] int_vec;
    reg [7:0] int_en;

    wire int_req;

    wire reg_w_en;

    reg [7:0] led_in_data;
    reg led_begin_flag;
    wire [7:0] led_state_reg;

    reg [7:0] nanaseg_in_data;

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
            .reg_w_en(reg_w_en));

    always @(posedge clock) begin
        if(rs_data == 8'd255 && mem_w_en == 1) begin
            tx_en <= rd_data[0];
            rx_en <= rd_data[1];
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

    assign mem_r_data = (rs_data == 8'd254) ? {6'b0, receive_flag, busy_flag}
                      : (rs_data == 8'd252) ? rx_data   //UART RX
                      : (rs_data == 8'd250) ? int_vec   //割り込みベクタ
                      : (rs_data == 8'd249) ? led_state_reg
                      : _mem_r_data;

    always @(posedge clock) begin
        if(rs_data == 8'd251 && mem_w_en == 1) begin
            led_in_data <= rd_data;
            led_begin_flag <= 1'b1;
        end else begin
            led_in_data <= led_in_data;
            led_begin_flag <= 1'b0;
        end
    end

    always @(posedge clock) begin
        if(rs_data == 8'd248 && mem_w_en == 1) begin
            nanaseg_in_data <= rd_data;
        end else begin
            nanaseg_in_data <= nanaseg_in_data;
        end
    end
    

    //割り込み要求が立っている時は割り込み不許可
    always @(posedge clock) begin
        if(int_req == 1'b1) begin
            int_en <= 8'h00;
        end else if(int_req == 1'b0) begin
            int_en <= 8'h01;
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

    LED4 LED4(.in_data(led_in_data),
              .begin_flag(led_begin_flag),
              .state_reg(led_state_reg),
              .out_data(led_out_data),
              .clock(clock));

    nanaseg nanaseg(.bin_in(nanaseg_in_data),
                    .seg_dig1(seg_out_1),
                    .seg_dig2(seg_out_2),
                    .seg_dig3(seg_out_3));

endmodule
