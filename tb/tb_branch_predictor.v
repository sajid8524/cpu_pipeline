`timescale 1ns/1ps

module tb_branch_predictor;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] pc;
    reg branch_taken;
    reg [31:0] branch_target;
    
    // Outputs
    wire prediction;
    wire [31:0] predicted_pc;
    
    // Instantiate the Unit Under Test (UUT)
    branch_predictor uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .prediction(prediction),
        .predicted_pc(predicted_pc)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        pc = 0;
        branch_taken = 0;
        branch_target = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: Initial prediction (weakly not taken)
        $display("Test 1: Initial prediction");
        pc = 32'h1000;
        #10;
        
        // Test 2: Train predictor to taken
        $display("\nTest 2: Train to taken");
        pc = 32'h1000;
        branch_taken = 1;
        branch_target = 32'h1040;
        #10;
        branch_taken = 0;
        #20;
        
        // Test 3: Check prediction after training
        $display("\nTest 3: Check trained prediction");
        pc = 32'h1000;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_branch_predictor.vcd");
        $dumpvars(0, tb_branch_predictor);
    end

endmodule