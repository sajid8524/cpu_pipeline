module forwarding_unit (
    // Inputs from pipeline stages
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,
    input [4:0] mem_rd,
    input mem_reg_write,
    input [4:0] wb_rd,
    input wb_reg_write,
    
    // Forwarding control signals
    output reg [1:0] forward_a,  // 00: no forwarding, 01: WB, 10: MEM
    output reg [1:0] forward_b   // 00: no forwarding, 01: WB, 10: MEM
);

    always @(*) begin
        // Defaults (no forwarding)
        forward_a = 2'b00;
        forward_b = 2'b00;
        
        // EX hazard (MEM -> EX forwarding)
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1)) begin
            forward_a = 2'b10;
        end
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2)) begin
            forward_b = 2'b10;
        end
        
        // MEM hazard (WB -> EX forwarding)
        if (wb_reg_write && (wb_rd != 0) && 
           !(mem_reg_write && (mem_rd == ex_rs1)) && (wb_rd == ex_rs1)) begin
            forward_a = 2'b01;
        end
        if (wb_reg_write && (wb_rd != 0) && 
           !(mem_reg_write && (mem_rd == ex_rs2)) && (wb_rd == ex_rs2)) begin
            forward_b = 2'b01;
        end
    end

endmodule