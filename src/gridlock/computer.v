module computer(
    input clock,
);
    
    instr_mem   instr_mem(
                    .addr   (pc     ),
                    .instr  (instr  )
                );

    cpu         cpu(
                    .pc             (pc         ),
                    .instr          (instr      ),
                    .EX_MEM_rs_data (rs_data    ),
                    .EX_MEM_rd_data (rd_data    ),
                    .EX_MEM_mem_w_en(mem_w_en   ),
                    .mem_r_data     (mem_r_data ),
                    .clock          (clock      ),
                );

    data_mem    data_mem(
                    .addr   (rs_data    ),
                    .w_data (rd_data    ),
                    .w_en   (mem_w_en   ),
                    .r_data (mem_r_data ),
                    .clock  (clock      )
                );

endmodule
