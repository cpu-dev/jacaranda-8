module cpu(
    input   wire            clock,
    input   wire    [7:0]   instr,
    input   wire    [7:0]   mem_r_data,
    output  reg     [7:0]   pc = 8'h00,
    output  reg     [7:0]   EX_MEM_rs_data = 8'h00,
    output  reg     [7:0]   EX_MEM_rd_data = 8'h00,
    output  reg             EX_MEM_mem_w_en = 0
);

    reg [7:0]   IF_ID_instr = 8'h00;

    reg [3:0]   ID_EX_opcode = 4'h0;
    reg [1:0]   ID_EX_rs_a;
    reg [7:0]   ID_EX_rs_data   = 8'h00;
    reg [1:0]   ID_EX_rd_a;
    reg [7:0]   ID_EX_rd_data   = 8'h00;
    reg [3:0]   ID_EX_imm;
    reg         ID_EX_reg_w_en;
    reg         ID_EX_mem_w_en;
    reg         ID_EX_reg_reg_mem_w_en;
    reg         ID_EX_imm_en;
    reg         ID_EX_ih_il_sel;
    reg         ID_EX_alu_ctrl;

    reg [7:0]   EX_MEM_alu_out;
    reg         EX_MEM_imm_en;
    reg [3:0]   EX_MEM_imm;
    reg [1:0]   EX_MEM_rs_a;
    reg [7:0]   EX_MEM_rs_data;
    reg [1:0]   EX_MEM_rd_a;
    reg [7:0]   EX_MEM_rd_data;
    reg         EX_MEM_reg_w_en;
    reg         EX_MEM_mem_w_en;
    reg         EX_MEM_ih_il_sel;
    reg         EX_MEM_reg_reg_mem_w_sel;

    reg         MEM_WB_ih_il_sel;
    reg         MEM_WB_imm_en;
    reg [3:0]   MEM_WB_imm;
    reg [7:0]   MEM_WB_rs_data;
    reg [7:0]   MEM_WB_alu_out;
    reg         MEM_wb_reg_w_en;
    reg         MEM_WB_reg_reg_mem_w_sel;
    reg [1:0]   MEM_WB_rd_a;
    reg [7:0]   MEM_WB_mem_r_data;

    decoder     decoder(
                    .instr  (IF_ID_instr),
                    .opcode (opcode     ),
                    .rs_a   (rs_a       ),
                    .rd_a   (rd_a       ),
                    .imm    (imm        )
                );

    assign reg_w_imm = MEM_WB_ih_il_sel ? {MEM_WB_imm, MEM_WB_rs_data[3:0]} 
                                        : {MEM_WB_rs_data[7:4], MEM_WB_imm};
    assign reg_w_data = MEM_WB_imm_en            ? reg_w_imm 
                      : MEM_WB_reg_reg_mem_w_sel ? MEM_WB_mem_r_data 
                                                 : MEM_WB_alu_out;
                       
    regfile     regfile(
                    .rs_addr    (imm_en ? 2'b11 : rs_a),
                    .rs_data    (rs_data        ),
                    .rd_addr    (imm_en ? 2'b11 : rd_a),
                    .rd_data    (rd_data        ),
                    .w_rd_data  (MEM_WB_rd_a    ),
                    .w_data     (reg_w_data     ),
                    .w_en       (MEM_WB_reg_w_en),
                    .clock      (clock          )
                );

    main_controller main_controller(
                        .opcode             (opcode             ),
                        .rd_a               (rd_a               ),
                        .reg_w_en           (reg_w_en           ),
                        .mem_w_en           (mem_w_en           ),
                        .reg_reg_mem_w_sel  (reg_reg_mem_w_sel  ),
                        .imm_en             (imm_en             ),
                        .ih_il_sel          (ih_il_sel          )
                    );

    alu_controller  alu_controller(
                        .opcode     (opcode     ),
                        .alu_ctrl   (alu_ctrl   )
                    );

    alu             alu(
                        .rd         (ID_EX_rd_data  ),
                        .rs         (ID_EX_rs_data  ),
                        .alu_ctrl   (ID_EX_alu_ctrl ),
                        .alu_out    (alu_out        )
                    );

    always @(posedge clk) begin
        pc <= pc + 1;
    end

    always @(posedge clk) begin
        IF_ID_instr <= instr;
    end

    always @(posedge clk) begin
        ID_EX_opcode    <= opcode;
        ID_EX_rs_a      <= rs_a;
        ID_EX_rs_data   <= rs_data;
        ID_EX_rd_a      <= rd_a;
        ID_EX_rd_data   <= rd_data;
        ID_EX_imm       <= imm;
        ID_EX_reg_w_en  <= reg_w_en;
        ID_EX_mem_w_en  <= mem_w_en;
        ID_EX_reg_reg_mem_w_sel <= reg_reg_mem_w_sel;
        ID_EX_imm_en    <= imm_en;
        ID_EX_ih_il_sel <= ih_il_sel;
        ID_EX_alu_ctrl  <= alu_ctrl;
    end

    always @(posedge clk) begin
        EX_MEM_alu_out  <= alu_out;
        EX_MEM_imm_en   <= ID_EX_imm_en;
        EX_MEM_imm      <= ID_EX_imm;
        EX_MEM_rs_a     <= ID_EX_rs_a;
        EX_MEM_rs_data  <= ID_EX_rs_data;
        EX_MEM_rd_a     <= ID_EX_rd_a;
        EX_MEM_rd_data  <= ID_EX_rd_data;
        EX_MEM_reg_w_en <= ID_EX_reg_w_en;
        EX_MEM_mem_w_en <= ID_EX_mem_w_en;
        EX_MEM_ih_il_sel    <= ID_EX_ih_il_sel;
        EX_MEM_reg_reg_mem_w_sel <= ID_EX_reg_reg_mem_w_sel;
    end

    always @(posedge clk) begin
        MEM_WB_ih_il_sel <= EX_MEM_ih_il_sel;
        MEM_WB_imm_en   <= EX_MEM_imm_en;
        MEM_WB_imm      <= EX_MEM_imm;
        MEM_WB_rs_data  <= EX_MEM_rs_data;
        MEM_WB_alu_out  <= EX_MEM_alu_out;
        MEM_WB_reg_w_en <= EX_MEM_reg_w_en;
        MEM_WB_reg_reg_mem_w_sel <= EX_MEM_reg_reg_mem_w_sel;
        MEM_WB_rd_a         <= EX_MEM_rd_a;
        MEM_WB_mem_r_data   <= mem_r_data;
    end

endmodule
