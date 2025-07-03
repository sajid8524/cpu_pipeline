`timescale 1ns/1ps

module tb_pipeline_basic;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [31:0] pc;

    // Instantiate the Unit Under Test (UUT)
    cpu_top uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Create waveform file
        $dumpfile("waveforms/tb_pipeline_basic.vcd");
        $dumpvars(0, tb_pipeline_basic);

        // Load test instructions into instruction memory
        $readmemh("programs/basic_test.hex", uut.IF.imem);

        // Hold reset for a short time
        #20;
        reset = 0;

        // Wait until the program reaches the end PC
        wait (pc == 32'h00000100);  // End address can be adjusted

        // Simulation completed
        $display(" Basic pipeline test completed at time %0t", $time);
        $finish;
    end

endmodule
