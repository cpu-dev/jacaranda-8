module regfile(rd_addr, rs_addr, w_data, w_en, rd_data, rs_data, clock, intr_en);
    input [1:0] rd_addr, rs_addr;
    input [1:0] w_rd_addr;
    input [7:0] w_data;
    input w_en;
    input clock;
    input intr_en;
    output [7:0] rs_data, rd_data;

    reg [7:0] register[0:3];
    reg [7:0] intr_register[0:3];

    assign rd_data = intr_en ? intr_register[rd_addr] : register[rd_addr];
    assign rs_data = intr_en ? intr_register[rs_addr] : register[rs_addr];
    always @(posedge clock) begin
        if(intr_en) begin
            if(w_en == 1) begin
                intr_register[w_rd_addr] <= w_data;
            end else begin
                intr_register[w_rd_addr] <= intr_register[w_rd_addr];
            end
        end else begin
            if(w_en == 1) begin
                register[w_rd_addr] <= w_data;
            end else begin
                register[w_rd_addr] <= register[w_rd_addr];
            end
        end
    end
endmodule
