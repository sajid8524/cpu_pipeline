module register_file (
    input clk,
    input reset,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input [31:0] write_data,
    input write_enable,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [0:31];
    integer i;

    // Write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'h0;
        end else if (write_enable && write_addr != 5'h0) begin
            registers[write_addr] <= write_data;
        end
    end

    // Read operations with write forwarding
    assign read_data1 = (read_addr1 == 5'h0) ? 32'h0 : 
                      ((write_enable && (read_addr1 == write_addr)) ? write_data : 
                       registers[read_addr1]);
    
    assign read_data2 = (read_addr2 == 5'h0) ? 32'h0 : 
                      ((write_enable && (read_addr2 == write_addr)) ? write_data : 
                       registers[read_addr2]);

endmodule