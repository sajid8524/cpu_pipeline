`timescale 1ns/1ps

module tb_control_flow;

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
        rs1_data = 32'h10;
        rs2_data = 32'h20;
        imm = 32'h40;
        opcode = 0;
        funct3 = 0;
        funct7 = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: BEQ (not taken)
        $display("Test 1: BEQ (not taken)");
        opcode = 7'b1100011; // B-type
        funct3 = 3'b000; // BEQ
        #10;
        
        // Test 2: BEQ (taken)
        $display("\nTest 2: BEQ (taken)");
        rs1_data = 32'h20;
        rs2_data = 32'h20;
        #10;
        
        // Test 3: JAL
        $display("\nTest 3: JAL");
        opcode = 7'b1101111; // JAL
        imm = 32'h100;
        #10;
        
        // Test 4: JALR
        $display("\nTest 4: JALR");
        opcode = 7'b1100111; // JALR
        rs1_data = 32'h2000;
        imm = 32'h10;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_control_flow.vcd");
        $dumpvars(0, tb_control_flow);
    end

endmodule