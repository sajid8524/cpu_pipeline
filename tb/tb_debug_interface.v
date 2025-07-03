`timescale 1ns/1ps

module tb_debug_interface;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] pc;
    reg [31:0] instruction;
    reg [31:0] reg_file [0:31];
    reg [31:0] csr_file [0:4095];
    reg debug_enable;
    reg [11:0] debug_addr;
    reg debug_read;
    reg debug_write;
    reg [31:0] debug_write_data;
    
    // Outputs
    wire [31:0] debug_read_data;
    wire debug_ready;
    
    // Instantiate the Unit Under Test (UUT)
    debug_interface uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .reg_file(reg_file),
        .csr_file(csr_file),
        .debug_enable(debug_enable),
        .debug_addr(debug_addr),
        .debug_read(debug_read),
        .debug_write(debug_write),
        .debug_write_data(debug_write_data),
        .debug_read_data(debug_read_data),
        .debug_ready(debug_ready)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        pc = 0;
        instruction = 0;
        debug_enable = 0;
        debug_addr = 0;
        debug_read = 0;
        debug_write = 0;
        debug_write_data = 0;
        
        // Initialize register and CSR files
        for (integer i = 0; i < 32; i = i + 1) begin
            reg_file[i] = i;
        end
        for (integer j = 0; j < 4096; j = j + 1) begin
            csr_file[j] = j;
        end
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        debug_enable = 1;
        
        // Test 1: Read register file
        $display("Test 1: Read register file");
        debug_addr = 12'h001; // x1
        debug_read = 1;
        #10;
        debug_read = 0;
        #10;
        
        // Test 2: Write register file
        $display("\nTest 2: Write register file");
        debug_addr = 12'h002; // x2
        debug_write_data = 32'h12345678;
        debug_write = 1;
        #10;
        debug_write = 0;
        #10;
        
        // Test 3: Read CSR file
        $display("\nTest 3: Read CSR file");
        debug_addr = 12'h801; // CSR with MSB set
        debug_read = 1;
        #10;
        debug_read = 0;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_debug_interface.vcd");
        $dumpvars(0, tb_debug_interface);
    end

endmodule