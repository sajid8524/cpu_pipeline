module stall_unit (
    input clk,
    input reset,
    input data_hazard,
    input control_hazard,
    input struct_hazard,
    output reg pc_stall,
    output reg if_stall,
    output reg id_stall,
    output reg ex_stall,
    output reg mem_stall
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_stall <= 1'b0;
            if_stall <= 1'b0;
            id_stall <= 1'b0;
            ex_stall <= 1'b0;
            mem_stall <= 1'b0;
        end else begin
            // Handle data hazards
            if (data_hazard) begin
                pc_stall <= 1'b1;
                if_stall <= 1'b1;
                id_stall <= 1'b1;
                ex_stall <= 1'b0;
                mem_stall <= 1'b0;
            end 
            // Handle control hazards
            else if (control_hazard) begin
                pc_stall <= 1'b0;
                if_stall <= 1'b0;
                id_stall <= 1'b0;
                ex_stall <= 1'b0;
                mem_stall <= 1'b0;
            end
            // Handle structural hazards
            else if (struct_hazard) begin
                pc_stall <= 1'b1;
                if_stall <= 1'b1;
                id_stall <= 1'b1;
                ex_stall <= 1'b1;
                mem_stall <= 1'b1;
            end else begin
                pc_stall <= 1'b0;
                if_stall <= 1'b0;
                id_stall <= 1'b0;
                ex_stall <= 1'b0;
                mem_stall <= 1'b0;
            end
        end
    end

endmodule