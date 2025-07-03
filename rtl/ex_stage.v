module ex_stage (
    input clk,
    input reset,
    input [31:0] pc,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] imm,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [31:0] alu_result,
    output reg branch_taken,
    output reg [31:0] branch_target,
    output reg ex_valid
);

    always @(*) begin
        // Default values
        alu_result = 32'h0;
        branch_taken = 1'b0;
        branch_target = pc + imm;
        
        // ALU operations
        case (opcode)
            7'b0110011: begin // R-type
                case (funct3)
                    3'b000: alu_result = (funct7[5] ? (rs1_data - rs2_data) : (rs1_data + rs2_data));
                    3'b001: alu_result = rs1_data << rs2_data[4:0];
                    3'b010: alu_result = ($signed(rs1_data)) < $signed(rs2_data) ? 32'h1 : 32'h0;
                    3'b011: alu_result = rs1_data < rs2_data ? 32'h1 : 32'h0;
                    3'b100: alu_result = rs1_data ^ rs2_data;
                    3'b101: alu_result = rs1_data >> rs2_data[4:0];
                    3'b110: alu_result = rs1_data | rs2_data;
                    3'b111: alu_result = rs1_data & rs2_data;
                endcase
            end
            7'b0010011: begin // I-type
                case (funct3)
                    3'b000: alu_result = rs1_data + imm;
                    3'b001: alu_result = rs1_data << imm[4:0];
                    3'b010: alu_result = ($signed(rs1_data)) < $signed(imm) ? 32'h1 : 32'h0;
                    3'b011: alu_result = rs1_data < imm ? 32'h1 : 32'h0;
                    3'b100: alu_result = rs1_data ^ imm;
                    3'b101: alu_result = funct7[5] ? ($signed(rs1_data)) >>> imm[4:0] : (rs1_data >> imm[4:0]);
                    3'b110: alu_result = rs1_data | imm;
                    3'b111: alu_result = rs1_data & imm;
                endcase
            end
            7'b1100011: begin // B-type (branches)
                case (funct3)
                    3'b000: branch_taken = (rs1_data == rs2_data);
                    3'b001: branch_taken = (rs1_data != rs2_data);
                    3'b100: branch_taken = ($signed(rs1_data)) < $signed(rs2_data);
                    3'b101: branch_taken = ($signed(rs1_data)) >= $signed(rs2_data);
                    3'b110: branch_taken = (rs1_data < rs2_data);
                    3'b111: branch_taken = (rs1_data >= rs2_data);
                endcase
            end
            7'b1101111: begin // JAL
                alu_result = pc + 4;
                branch_taken = 1'b1;
                branch_target = pc + imm;
            end
            7'b1100111: begin // JALR
                alu_result = pc + 4;
                branch_taken = 1'b1;
                branch_target = rs1_data + imm;
            end
            default: alu_result = 32'h0;
        endcase
    end

    // Pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_valid <= 1'b0;
        end else begin
            ex_valid <= 1'b1;
        end
    end

endmodule