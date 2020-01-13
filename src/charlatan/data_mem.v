module data_mem(addr, w_data, w_en, r_data, clock, dbg_mem_0, dbg_mem_1);
    input [7:0] addr;
    input [7:0] w_data;
    input w_en;
    input clock;
    output [7:0] r_data;
    output [7:0] dbg_mem_0, dbg_mem_1;

    reg [7:0] mem[0:255];
    
    assign r_data = mem[addr];
    assign dbg_mem_0 = mem[0];
    assign dbg_mem_1 = mem[1];

    always @(posedge clock) begin
        if(w_en) begin
            mem[addr] <= w_data;
        end else begin
            mem[addr] <= mem[addr];
        end
    end
endmodule
