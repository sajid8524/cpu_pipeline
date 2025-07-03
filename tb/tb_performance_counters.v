`timescale 1ns/1ps

module tb_performance_counters;

    // Inputs
    reg clk;
    reg reset;
    reg instruction_retired;
    reg cycle_count_en;
    reg [31:0] event_signals;
    
    // Outputs
    wire [31:0] cycle_count;
    wire [31:0] instret_count;
    wire [31:0] event_counts [0:31];
    
    // Instantiate the Unit Under Test (UUT)
    performance_counters uut (
        .clk(clk),
        .reset(reset),
        .instruction_retired(instruction_retired),
        .cycle_count_en(cycle_count_en),
        .event_signals(event_signals),
        .cycle_count(cycle_count),
        .instret_count(instret_count),
        .event_counts(event_counts)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        instruction_retired = 0;
        cycle_count_en = 0;
        event_signals = 0;
        
        // Wait 100 ns for global reset
        #100;
        reset = 0;
        cycle_count_en = 1;
        
        // Test 1: Count cycles and instructions
        $display("Test 1: Counting cycles and instructions");
        instruction_retired = 1;
        #100;
        instruction_retired = 0;
        #50;
        
        // Test 2: Count events
        $display("\nTest 2: Counting events");
        event_signals = 32'h00000003; // Events 0 and 1
        #30;
        event_signals = 32'h00000001; // Event 0 only
        #20;
        event_signals = 0;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_performance_counters.vcd");
        $dumpvars(0, tb_performance_counters);
        
        // Display event counts
        always @(posedge clk) begin
            $display("Cycle: %d, Instret: %d, Event0: %d, Event1: %d",
                     cycle_count, instret_count, event_counts[0], event_counts[1]);
        end
    end

endmodule