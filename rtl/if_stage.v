module if_stage (
    input clk,
    input reset,
    input stall,
    input flush,
    input [31:0] branch_target,
    input branch_taken,
    output reg [31:0] pc,
    output [31:0] instruction,
    output reg if_valid
);

    reg [31:0] pc_next;
    reg [31:0] imem [0:1023];  // 4KB instruction memory
    
    // Initialize instruction memory with some simple instructions
    initial begin
        // addi x1, x0, 10
        imem[0] = 32'h00a00093;
        // addi x2, x1, 5
        imem[1] = 32'h00508113;
        // add x3, x1, x2
        imem[2] = 32'h002081b3;
        // beq x3, x1, -4 (dummy branch)
        imem[3] = 32'hfe718ce3;
        // nop
        imem[4] = 32'h00000013;
    end
    
    // PC update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h00000000;
            if_valid <= 1'b0;
        end else if (flush) begin
            pc <= branch_target;
            if_valid <= 1'b0;
        end else if (!stall) begin
            pc <= pc_next;
            if_valid <= 1'b1;
        end
    end
    
    // Next PC calculation
    always @(*) begin
        if (branch_taken)
            pc_next = branch_target;
        else
            pc_next = pc + 4;
    end
    
    // Instruction memory access
    assign instruction = imem[pc[11:2]];  // Word-aligned access

endmodule