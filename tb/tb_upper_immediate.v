`timescale 1ns/1ps

module tb_upper_immediate;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] pc;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] imm;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    
    // Outputs
    wire [31:0] alu_result;
    wire branch_taken;
    wire [31:0] branch_target;
    wire ex_valid;
    
    // Instantiate the Unit Under Test (UUT)
    ex_stage uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_result(alu_result),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .ex_valid(ex_valid)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        pc = 32'h1000;
        rs1_data = 0;
        rs2_data = 0;
        imm = 0;
        opcode = 0;
        funct3 = 0;
        funct7 = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: LUI
        $display("Test 1: LUI");
        opcode = 7'b0110111; // LUI
        imm = 32'h12345000;
        #10;
        
        // Test 2: AUIPC
        $display("\nTest 2: AUIPC");
        opcode = 7'b0010111; // AUIPC
        pc = 32'h1000;
        imm = 32'h1000;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_upper_immediate.vcd");
        $dumpvars(0, tb_upper_immediate);
    end

endmodule