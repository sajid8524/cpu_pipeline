module performance_counters (
    input clk,
    input reset,
    input instruction_retired,
    input cycle_count_en,
    input [31:0] event_signals,  // Various event signals to count
    output [31:0] cycle_count,
    output [31:0] instret_count,
    output [31:0] event_counts [0:31]
);

    reg [31:0] cycle_counter;
    reg [31:0] instret_counter;
    reg [31:0] event_counters [0:31];
    
    assign cycle_count = cycle_counter;
    assign instret_count = instret_counter;
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign event_counts[i] = event_counters[i];
        end
    endgenerate
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cycle_counter <= 32'h0;
            instret_counter <= 32'h0;
            for (integer j = 0; j < 32; j = j + 1) begin
                event_counters[j] <= 32'h0;
            end
        end else begin
            if (cycle_count_en) begin
                cycle_counter <= cycle_counter + 1;
            end
            
            if (instruction_retired) begin
                instret_counter <= instret_counter + 1;
            end
            
            for (integer j = 0; j < 32; j = j + 1) begin
                if (event_signals[j]) begin
                    event_counters[j] <= event_counters[j] + 1;
                end
            end
        end
    end

endmodule