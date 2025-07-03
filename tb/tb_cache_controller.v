`timescale 1ns/1ps

module tb_cache_controller;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_read;
    reg mem_write;
    reg [31:0] mem_read_data;
    reg mem_ready;
    
    // Outputs
    wire [31:0] read_data;
    wire ready;
    wire [31:0] mem_address;
    wire [31:0] mem_write_data;
    wire mem_read_req;
    wire mem_write_req;
    
    // Instantiate the Unit Under Test (UUT)
    cache_controller uut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data),
        .ready(ready),
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
        address = 0;
        write_data = 0;
        mem_read = 0;
        mem_write = 0;
        mem_read_data = 0;
        mem_ready = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: Cache read miss
        $display("Test 1: Cache read miss");
        mem_read = 1;
        address = 32'h1000;
        #20;
        mem_ready = 1;
        mem_read_data = 32'h12345678;
        #10;
        mem_ready = 0;
        mem_read = 0;
        #20;
        
        // Test 2: Cache read hit
        $display("\nTest 2: Cache read hit");
        mem_read = 1;
        address = 32'h1000;
        #10;
        mem_read = 0;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_cache_controller.vcd");
        $dumpvars(0, tb_cache_controller);
    end

endmodule