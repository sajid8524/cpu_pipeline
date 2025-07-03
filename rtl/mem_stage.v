module mem_stage (
    input clk,
    input reset,
    // From EX stage
    input [31:0] alu_result_in,
    input [31:0] rs2_data_in,
    input [2:0] funct3_in,  // Memory operation type
    input mem_read_in,
    input mem_write_in,
    // To WB stage
    output reg [31:0] alu_result_out,
    output reg [31:0] mem_data_out,
    output reg mem_valid,
    // Memory interface
    output [31:0] mem_address,
    output [31:0] mem_write_data,
    output mem_read_req,
    output mem_write_req,
    input [31:0] mem_read_data,
    input mem_ready
);

    // Data memory
    reg [7:0] dmem [0:1023];  // 1KB data memory (byte-addressable)
    
    // Internal signals
    reg [31:0] loaded_data;
    
    // Memory interface
    assign mem_address = alu_result_in;
    assign mem_write_data = rs2_data_in;
    assign mem_read_req = mem_read_in;
    assign mem_write_req = mem_write_in;
    
    // Load operations
    always @(*) begin
        case (funct3_in)
            3'b000: loaded_data = {{24{dmem[alu_result_in[9:0]][7]}}, dmem[alu_result_in[9:0]]};  // LB
            3'b001: loaded_data = {{16{dmem[alu_result_in[9:0]+1][7]}}, dmem[alu_result_in[9:0]+1], dmem[alu_result_in[9:0]]};  // LH
            3'b010: loaded_data = {dmem[alu_result_in[9:0]+3], dmem[alu_result_in[9:0]+2], 
                                 dmem[alu_result_in[9:0]+1], dmem[alu_result_in[9:0]]};  // LW
            3'b100: loaded_data = {24'h0, dmem[alu_result_in[9:0]]};  // LBU
            3'b101: loaded_data = {16'h0, dmem[alu_result_in[9:0]+1], dmem[alu_result_in[9:0]]};  // LHU
            default: loaded_data = 32'h0;
        endcase
    end
    
    // Store operations
    always @(posedge clk) begin
        if (mem_write_in && mem_ready) begin
            case (funct3_in)
                3'b000: begin  // SB
                    dmem[alu_result_in[9:0]] <= rs2_data_in[7:0];
                end
                3'b001: begin  // SH
                    dmem[alu_result_in[9:0]] <= rs2_data_in[7:0];
                    dmem[alu_result_in[9:0]+1] <= rs2_data_in[15:8];
                end
                3'b010: begin  // SW
                    dmem[alu_result_in[9:0]] <= rs2_data_in[7:0];
                    dmem[alu_result_in[9:0]+1] <= rs2_data_in[15:8];
                    dmem[alu_result_in[9:0]+2] <= rs2_data_in[23:16];
                    dmem[alu_result_in[9:0]+3] <= rs2_data_in[31:24];
                end
            endcase
        end
    end
    
    // Pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'h0;
            mem_data_out <= 32'h0;
            mem_valid <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            mem_data_out <= mem_read_in ? loaded_data : 32'h0;
            mem_valid <= 1'b1;
        end
    end

endmodule