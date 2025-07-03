module cpu_top (
    input clk,
    input reset,
    output [31:0] pc_out
);

    // Pipeline registers
    wire [31:0] if_pc, if_instruction;
    wire if_valid;
    
    wire [31:0] id_pc, id_instruction;
    wire [31:0] id_rs1_data, id_rs2_data, id_imm;
    wire [4:0] id_rd;
    wire [6:0] id_opcode;
    wire [2:0] id_funct3;
    wire [6:0] id_funct7;
    wire id_valid;
    
    wire [31:0] ex_alu_result;
    wire [4:0] ex_rd;
    wire ex_valid;
    
    wire [31:0] mem_data;
    wire [4:0] mem_rd;
    wire mem_valid;
    
    wire wb_valid;

    // Hazard detection signals
    wire pc_stall, if_stall, id_stall, ex_stall, mem_stall;
    
    // Control signals
    wire branch_taken;
    wire [31:0] branch_target;

    // Instantiate pipeline stages
    if_stage IF (
        .clk(clk),
        .reset(reset),
        .stall(pc_stall),
        .flush(branch_taken),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .pc(if_pc),
        .instruction(if_instruction),
        .if_valid(if_valid)
    );

    id_stage ID (
        .clk(clk),
        .reset(reset),
        .pc_in(if_pc),
        .instruction_in(if_instruction),
        .pc_out(id_pc),
        .instruction_out(id_instruction),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data),
        .imm(id_imm),
        .rd(id_rd),
        .opcode(id_opcode),
        .funct3(id_funct3),
        .funct7(id_funct7),
        .id_valid(id_valid)
    );

    ex_stage EX (
        .clk(clk),
        .reset(reset),
        .pc(id_pc),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data),
        .imm(id_imm),
        .opcode(id_opcode),
        .funct3(id_funct3),
        .funct7(id_funct7),
        .alu_result(ex_alu_result),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .ex_valid(ex_valid)
    );

    mem_stage MEM (
        .clk(clk),
        .reset(reset),
        .alu_result_in(ex_alu_result),
        .alu_result_out(mem_data),
        .mem_valid(mem_valid)
    );

    wb_stage WB (
        .clk(clk),
        .reset(reset),
        .mem_data(mem_data),
        .wb_valid(wb_valid)
    );

    // Output the current PC
    assign pc_out = if_pc;

endmodule