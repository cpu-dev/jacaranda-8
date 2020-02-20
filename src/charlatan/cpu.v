module cpu(clock, instr, pc, rd_data, rs_data, mem_w_en, mem_r_data, int_req, int_en, int_vec, reg_w_en, ret_addr);
    input clock;
    input [7:0] instr;
    //割り込み要求線
    input int_req;
    //割り込みイネーブル
    input [7:0] int_en;
    //割り込みベクタ
    input [7:0] int_vec;

    output [7:0] pc;
    output [7:0] ret_addr;
    //レジスタから読み込んだデータ
    output [7:0] rd_data, rs_data;
    //メモリにデータを書き込むか
    output mem_w_en;
    //メモリから読み込んだデータ
    input [7:0] mem_r_data;
    reg flag;
    reg [7:0] pc = 0;
    
    wire [3:0] opcode;
    wire [1:0] rd_a, rd_a_p, rs_a, rs_a_p;
    wire [3:0] imm;

    //レジスタにデータを書き込むか
    output reg_w_en;
    //レジスタに書き込むデータとそのバッファ
    wire [7:0] reg_w_data;
    wire [7:0] reg_w_data_p;
    wire [7:0] reg_w_data_p_p;
    wire [7:0] reg_w_imm;

    //レジスタに書き込むデータをレジスタ(0)かメモリ(1)からか選択する
    wire reg_reg_mem_w_sel;
    //レジスタに書き込むデータをALUからのデータか選択する(1)でALUから(0)でそれ以外
    wire reg_alu_w_sel;


    //ALUの制御信号
    wire [3:0] alu_ctrl;
    //ALUからの出力
    wire [7:0] alu_out;

    //flagに書き込みを行うか
    wire flag_w_en;

    //即値ロードの場合のみ(1)になる信号
    wire imm_en;
    //ldih(1)かldil(0)かの信号
    wire ih_il_sel;

    //jmp, je実行時に(1)になる信号
    wire jmp_en, je_en;

    decoder decoder(instr, opcode, rs_a_p, rd_a_p, imm);

    main_controller main_controller(opcode, reg_w_en, mem_w_en, reg_reg_mem_w_sel, reg_alu_w_sel, flag_w_en, imm_en, ih_il_sel, jmp_en, je_en);
    alu_controller alu_controller(opcode, alu_ctrl);

    regfile regfile(rd_a, rs_a, reg_w_data, reg_w_en, rd_data, rs_data, clock);
    //即値ロード時のみrd_a, rs_aを3に
    assign rd_a = imm_en ? 2'b11 : rd_a_p;
    assign rs_a = imm_en ? 2'b11 : rs_a_p;
    //レジスタに書き込むデータの出元を選択
    assign reg_w_data_p_p = reg_reg_mem_w_sel ? mem_r_data : rs_data;
    assign reg_w_data_p = reg_alu_w_sel ? alu_out : reg_w_data_p_p;
    assign reg_w_imm = ih_il_sel ? {imm, rs_data[3:0]} : {rs_data[7:4], imm};
    assign reg_w_data = imm_en ? reg_w_imm : reg_w_data_p;

    alu alu(rd_data, rs_data, alu_ctrl, alu_out);
    //フラグレジスタ書き込み
    always @(posedge clock) begin
        if(je_en) begin
            flag <= 0;
        end else if(flag_w_en) begin
            flag <= alu_out;
        end else begin
            flag <= flag;
        end
    end

    //戻りアドレスの格納
    assign ret_addr = jmp_en ? rs_data
                    : je_en ? flag ? rs_data : pc + 1
                    : pc + 1;

    always @(posedge clock) begin
        if(int_req && int_en[0]) begin
            pc <= int_vec;
        end else if(jmp_en) begin
            pc <= rs_data;
        end else if(je_en) begin
            if(flag) begin
                pc <= rs_data;
            end else begin
                pc <= pc + 1;
            end
        end else begin
            pc <= pc + 1;
        end
    end
endmodule
