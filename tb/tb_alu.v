// Testbench for ALU Module
// Tests all ALU operations and verifies functionality

`timescale 1ns/1ps

module tb_alu;

// Testbench signals
reg [31:0] a;
reg [31:0] b;
reg [3:0] alu_control;
wire [31:0] result;
wire zero;

// Error tracking
integer error_count = 0;
integer test_count = 0;

// Instantiate ALU
alu uut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result),
    .zero(zero)
);

// Task to check results
task check_result;
    input [31:0] expected;
    input [3:0] operation;
    input [31:0] a_val, b_val;
    begin
        test_count = test_count + 1;
        if (result !== expected) begin
            $display("ERROR: Test %d failed", test_count);
            $display("  Operation: %b, A: %d, B: %d", operation, a_val, b_val);
            $display("  Expected: %d, Got: %d", expected, result);
            error_count = error_count + 1;
        end else begin
            $display("PASS: Test %d - Op:%b A:%d B:%d Result:%d", 
                     test_count, operation, a_val, b_val, result);
        end
    end
endtask

// Main test sequence
initial begin
    $dumpfile("alu_test.vcd");
    $dumpvars(0, tb_alu);
    
    $display("Starting ALU Tests...");
    $display("=====================");
    
    // Test ADD operation
    a = 32'd15; b = 32'd25; alu_control = 4'b0000;
    #10; check_result(32'd40, alu_control, a, b);
    
    // Test SUB operation
    a = 32'd50; b = 32'd20; alu_control = 4'b0001;
    #10; check_result(32'd30, alu_control, a, b);
    
    // Test AND operation
    a = 32'hFF00FF00; b = 32'h0FF00FF0; alu_control = 4'b0010;
    #10; check_result(32'h0F000F00, alu_control, a, b);
    
    // Test OR operation
    a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_control = 4'b0011;
    #10; check_result(32'hFFFFFFFF, alu_control, a, b);
    
    // Test XOR operation
    a = 32'hAAAAAAAA; b = 32'h55555555; alu_control = 4'b0100;
    #10; check_result(32'hFFFFFFFF, alu_control, a, b);
    
    // Test SLL (Shift Left Logical)
    a = 32'h00000001; b = 32'd4; alu_control = 4'b0101;
    #10; check_result(32'h00000010, alu_control, a, b);
    
    // Test SRL (Shift Right Logical)
    a = 32'h80000000; b = 32'd4; alu_control = 4'b0110;
    #10; check_result(32'h08000000, alu_control, a, b);
    
    // Test SRA (Shift Right Arithmetic)
    a = 32'h80000000; b = 32'd4; alu_control = 4'b0111;
    #10; check_result(32'hF8000000, alu_control, a, b);
    
    // Test SLT (Set Less Than) - signed
    a = 32'hFFFFFFFF; b = 32'h00000001; alu_control = 4'b1000; // -1 < 1
    #10; check_result(32'h00000001, alu_control, a, b);
    
    // Test SLTU (Set Less Than Unsigned)
    a = 32'hFFFFFFFF; b = 32'h00000001; alu_control = 4'b1001; // 0xFFFFFFFF > 1
    #10; check_result(32'h00000000, alu_control, a, b);
    
    // Test Zero Flag
    a = 32'd5; b = 32'd5; alu_control = 4'b0001; // 5 - 5 = 0
    #10;
    if (zero !== 1'b1) begin
        $display("ERROR: Zero flag should be 1 when result is 0");
        error_count = error_count + 1;
    end else begin
        $display("PASS: Zero flag correctly set");
    end
    
    // Edge cases
    $display("\nTesting Edge Cases...");
    
    // Maximum values
    a = 32'hFFFFFFFF; b = 32'h00000001; alu_control = 4'b0000;
    #10; // This will overflow, just check it doesn't crash
    
    // Zero operands
    a = 32'h00000000; b = 32'h00000000; alu_control = 4'b0011;
    #10; check_result(32'h00000000, alu_control, a, b);
    
    // Test Summary
    $display("\n=====================");
    $display("Test Summary:");
    $display("Total Tests: %d", test_count);
    $display("Errors: %d", error_count);
    
    if (error_count == 0) begin
        $display("ALL TESTS PASSED!");
    end else begin
        $display("SOME TESTS FAILED!");
    end
    
    $display("Simulation completed at time: %t", $time);
    $finish;
end

endmodule