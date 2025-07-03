module branch_predictor (
    input clk,
    input reset,
    input [31:0] pc,
    input branch_taken,
    input [31:0] branch_target,
    output reg prediction,
    output [31:0] predicted_pc
);

    // 2-bit saturating counter predictor
    reg [1:0] prediction_state [0:1023];  // 1K-entry prediction table
    
    integer i;
    
    // Initialize prediction table
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            prediction_state[i] = 2'b01;  // Weakly not taken
        end
    end
    
    // Make prediction
    always @(*) begin
        prediction = prediction_state[pc[11:2]][1];  // Use MSB as prediction
    end
    
    assign predicted_pc = prediction ? (pc + branch_target) : (pc + 4);
    
    // Update predictor
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 1024; i = i + 1) begin
                prediction_state[i] <= 2'b01;
            end
        end else begin
            if (branch_taken) begin
                // Increment counter (saturating at 3)
                if (prediction_state[pc[11:2]] != 2'b11) begin
                    prediction_state[pc[11:2]] <= prediction_state[pc[11:2]] + 1;
                end
            end else begin
                // Decrement counter (saturating at 0)
                if (prediction_state[pc[11:2]] != 2'b00) begin
                    prediction_state[pc[11:2]] <= prediction_state[pc[11:2]] - 1;
                end
            end
        end
    end

endmodule