module wb_stage (
    input clk,
    input reset,
    input [31:0] mem_data,
    output reg wb_valid
);

    // Simple write back stage
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_valid <= 1'b0;
        end else begin
            wb_valid <= 1'b1;
        end
    end

endmodule