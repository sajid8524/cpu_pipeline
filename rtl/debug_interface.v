module debug_interface (
    input clk,
    input reset,
    // CPU interface
    input [31:0] pc,
    input [31:0] instruction,
    input [31:0] reg_file [0:31],
    input [31:0] csr_file [0:4095],
    // External interface
    input debug_enable,
    input [11:0] debug_addr,
    input debug_read,
    input debug_write,
    input [31:0] debug_write_data,
    output [31:0] debug_read_data,
    output debug_ready
);

    reg [31:0] debug_data;
    reg ready;
    
    assign debug_read_data = debug_data;
    assign debug_ready = ready;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debug_data <= 32'h0;
            ready <= 1'b0;
        end else begin
            ready <= 1'b0;
            
            if (debug_enable) begin
                if (debug_read) begin
                    case (debug_addr[11])
                        1'b0: debug_data <= reg_file[debug_addr[4:0]];
                        1'b1: debug_data <= csr_file[debug_addr[11:0]];
                    endcase
                    ready <= 1'b1;
                end
                
                if (debug_write) begin
                    case (debug_addr[11])
                        1'b0: reg_file[debug_addr[4:0]] <= debug_write_data;
                        1'b1: csr_file[debug_addr[11:0]] <= debug_write_data;
                    endcase
                    ready <= 1'b1;
                end
            end
        end
    end

endmodule