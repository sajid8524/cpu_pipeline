`timescale 1ns/1ps

module tb_mem_stage;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] alu_result_in;
    reg [31:0] rs2_data_in;
    reg [2:0] funct3_in;
    reg mem_read_in;
    reg mem_write_in;
    reg [31:0] mem_read_data;
    reg mem_ready;
    
    // Outputs
    wire [31:0] alu_result_out;
    wire [31:0] mem_data_out;
    wire mem_valid;
    wire [31:0] mem_address;
    wire [31:0] mem_write_data;
    wire mem_read_req;
    wire mem_write_req;
    
    // Instantiate the Unit Under Test (UUT)
    mem_stage uut (
        .clk(clk),
        .reset(reset),
        .alu_result_in(alu_result_in),
        .rs2_data_in(rs2_data_in),
        .funct3_in(funct3_in),
        .mem_read_in(mem_read_in),
        .mem_write_in(mem_write_in),
        .alu_result_out(alu_result_out),
        .mem_data_out(mem_data_out),
        .mem_valid(mem_valid),
        .mem_address(mem_address),
        .mem_write_data(mem_write_data),
        .mem_read_req(mem_read_req),
        .mem_write_req(mem_write_req),
        .mem_read_data(mem_read_data),
        .mem_ready(mem_ready)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        alu_result_in = 0;
        rs2_data_in = 0;
        funct3_in = 0;
        mem_read_in = 0;
        mem_write_in = 0;
        mem_read_data = 0;
        mem_ready = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: LW operation
        $display("Test 1: LW operation");
        alu_result_in = 32'h100;
        mem_read_data = 32'h12345678;
        mem_read_in = 1;
        funct3_in = 3'b010; // LW
        #10;
        mem_ready = 1;
        #10;
        mem_read_in = 0;
        mem_ready = 0;
        #20;
        
        // Test 2: SW operation
        $display("\nTest 2: SW operation");
        alu_result_in = 32'h104;
        rs2_data_in = 32'h89ABCDEF;
        mem_write_in = 1;
        funct3_in = 3'b010; // SW
        #10;
        mem_ready = 1;
        #10;
        mem_write_in = 0;
        mem_ready = 0;
        #20;
        
        // Test 3: LB operation with sign extension
        $display("\nTest 3: LB operation");
        alu_result_in = 32'h108;
        mem_read_data = 32'h000000F0;
        mem_read_in = 1;
        funct3_in = 3'b000; // LB
        #10;
        mem_ready = 1;
        #10;
        mem_read_in = 0;
        mem_ready = 0;
        #20;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_mem_stage.vcd");
        $dumpvars(0, tb_mem_stage);
    end

endmodule