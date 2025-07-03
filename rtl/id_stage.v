module id_stage (
    input clk,
    input reset,
    input [31:0] pc_in,
    input [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out,
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    output [31:0] imm,
    output reg [4:0] rd,
    output reg [6:0] opcode,
    output reg [2:0] funct3,
    output reg [6:0] funct7,
    output reg id_valid
);

    // Register file
    reg [31:0] registers [0:31];
    
    // Immediate generation
    assign imm = (opcode == 7'b0010011) ? {{20{instruction_in[31]}}, instruction_in[31:20]} :  // I-type
                 (opcode == 7'b0100011) ? {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]} :  // S-type
                 (opcode == 7'b1100011) ? {{20{instruction_in[31]}}, instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0} :  // B-type
                 32'h0;
    
    // Register file read
    assign rs1_data = (instruction_in[19:15] == 5'b0) ? 32'h0 : registers[instruction_in[19:15]];
    assign rs2_data = (instruction_in[24:20] == 5'b0) ? 32'h0 : registers[instruction_in[24:20]];
    
    // Pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'h0;
            instruction_out <= 32'h0;
            opcode <= 7'h0;
            funct3 <= 3'h0;
            funct7 <= 7'h0;
            rd <= 5'h0;
            id_valid <= 1'b0;
        end else begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
            opcode <= instruction_in[6:0];
            funct3 <= instruction_in[14:12];
            funct7 <= instruction_in[31:25];
            rd <= instruction_in[11:7];
            id_valid <= 1'b1;
        end
    end

endmodule