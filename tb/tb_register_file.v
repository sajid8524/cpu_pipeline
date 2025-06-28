`timescale 1ns/1ps

module tb_register_file;

    // Inputs
    reg clk;
    reg reset;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr;
    reg [31:0] write_data;
    reg write_enable;

    // Outputs
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .reset(reset),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        write_enable = 0;

        // Create waveform file
        $dumpfile("waveforms/register_file.vcd");
        $dumpvars(0, tb_register_file);

        // Apply reset
        #10 reset = 0;

        // Test 1: Basic write and read
        $display("Test 1: Basic write and read");
        write_addr = 5'h1; 
        write_data = 32'h12345678; 
        write_enable = 1;
        #10;
        write_enable = 0;
        read_addr1 = 5'h1;
        #5;
        if (read_data1 !== 32'h12345678) $display("Error: Read data1 mismatch");
        else $display("PASS: Basic write/read");

        // Test 2: Write to x0 (should be ignored)
        $display("\nTest 2: Write to x0");
        write_addr = 5'h0;
        write_data = 32'hDEADBEEF;
        write_enable = 1;
        #10;
        write_enable = 0;
        read_addr1 = 5'h0;
        #5;
        if (read_data1 !== 32'h0) $display("Error: x0 was modified");
        else $display("PASS: x0 remains zero");

        // Test 3: Write forwarding
        $display("\nTest 3: Write forwarding");
        write_addr = 5'h2;
        write_data = 32'hABCDEF01;
        write_enable = 1;
        read_addr1 = 5'h2; // Read same address being written
        #5;
        if (read_data1 !== 32'hABCDEF01) $display("Error: Write forwarding failed");
        else $display("PASS: Write forwarding works");

        // Test 4: Simultaneous read/write different registers
        $display("\nTest 4: Simultaneous read/write");
        write_addr = 5'h3;
        write_data = 32'hCAFEBABE;
        write_enable = 1;
        read_addr1 = 5'h1; // Read previous value
        read_addr2 = 5'h3; // Read new value being written
        #5;
        if (read_data1 !== 32'h12345678 || read_data2 !== 32'hCAFEBABE) 
            $display("Error: Simultaneous read/write failed");
        else $display("PASS: Simultaneous read/write works");

        // Finish simulation
        #10 $finish;
    end
    
endmodule