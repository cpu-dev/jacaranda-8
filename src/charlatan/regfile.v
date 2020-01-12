module regfile(rd_addr, rs_addr, w_data, w_en, rd_data, rs_data, clock);
    input [1:0] rd_addr, rs_addr;
    input [7:0] w_data;
    input w_en;
    input clock;
    output [7:0] rs_data, rd_data;

    reg [7:0] register[4];

    assign rd_data = register[rd_addr];
    assign rs_data = register[rs_addr];
    always @(posedge clock) begin
        if(w_en == 1) begin
            register[rd_addr] <= w_data;
        end else begin
            register[rd_addr] <= register[rd_addr];
        end
    end
endmodule
