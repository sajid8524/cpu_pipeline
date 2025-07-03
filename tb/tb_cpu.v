`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg reset;
    wire [31:0] pc;
    
    // Instantiate the CPU
    cpu_top uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        
        // Create waveform file
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
        
        // Apply reset
        #20 reset = 0;
        
        // Run for 100 clock cycles
        #1000;
        
        $display("Simulation completed");
        $finish;
    end

endmodule