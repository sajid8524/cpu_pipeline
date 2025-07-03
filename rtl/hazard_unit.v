module hazard_unit (
    // Inputs from pipeline stages
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] ex_rd,
    input ex_mem_read,       // EX stage is doing a load
    input [4:0] mem_rd,
    input mem_reg_write,     // MEM stage will write to register
    input [4:0] wb_rd,
    input wb_reg_write,      // WB stage will write to register
    input branch_taken,      // Branch is taken
    
    // Output stall signals
    output reg pc_stall,     // Stall PC
    output reg if_stall,     // Stall IF stage
    output reg id_stall,     // Stall ID stage
    output reg ex_stall,     // Stall EX stage
    output reg mem_stall,    // Stall MEM stage
    output reg if_flush,     // Flush IF stage
    output reg id_flush,     // Flush ID stage
    output reg ex_flush      // Flush EX stage
);

    always @(*) begin
        // Default values
        pc_stall = 1'b0;
        if_stall = 1'b0;
        id_stall = 1'b0;
        ex_stall = 1'b0;
        mem_stall = 1'b0;
        if_flush = 1'b0;
        id_flush = 1'b0;
        ex_flush = 1'b0;
        
        // Load-use hazard detection
        if (ex_mem_read && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            pc_stall = 1'b1;
            if_stall = 1'b1;
            id_stall = 1'b1;
            ex_flush = 1'b1;
        end
        
        // Control hazard (branch misprediction)
        if (branch_taken) begin
            if_flush = 1'b1;
            id_flush = 1'b1;
            ex_flush = 1'b1;
        end
    end

endmodule