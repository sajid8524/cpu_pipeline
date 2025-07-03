module cache_controller (
    input clk,
    input reset,
    // Processor interface
    input [31:0] address,
    input [31:0] write_data,
    input mem_read,
    input mem_write,
    output [31:0] read_data,
    output ready,
    // Memory interface
    output [31:0] mem_address,
    output [31:0] mem_write_data,
    output mem_read_req,
    output mem_write_req,
    input [31:0] mem_read_data,
    input mem_ready
);

    // Cache parameters
    parameter CACHE_SIZE = 1024;  // 1KB cache
    parameter BLOCK_SIZE = 32;    // 32-byte blocks
    
    // Cache memory
    reg [31:0] cache_data [0:CACHE_SIZE/4-1];
    reg [31:0] cache_tags [0:CACHE_SIZE/BLOCK_SIZE-1];
    reg cache_valid [0:CACHE_SIZE/BLOCK_SIZE-1];
    
    // State machine
    reg [1:0] state;
    reg [31:0] saved_address;
    reg [31:0] saved_write_data;
    reg saved_mem_write;
    
    // States
    localparam IDLE = 2'b00;
    localparam READ_MEM = 2'b01;
    localparam WRITE_MEM = 2'b10;
    
    assign ready = (state == IDLE);
    assign read_data = cache_data[address[9:2]];  // Simple direct-mapped cache
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            for (integer i = 0; i < CACHE_SIZE/BLOCK_SIZE; i = i + 1) begin
                cache_valid[i] <= 1'b0;
            end
        end else begin
            case (state)
                IDLE: begin
                    if (mem_read || mem_write) begin
                        saved_address <= address;
                        saved_write_data <= write_data;
                        saved_mem_write <= mem_write;
                        
                        if (cache_valid[address[9:5]] && 
                            (cache_tags[address[9:5]] == address[31:10])) begin
                            // Cache hit
                            if (mem_write) begin
                                cache_data[address[9:2]] <= write_data;
                            end
                        end else begin
                            // Cache miss
                            state <= mem_write ? WRITE_MEM : READ_MEM;
                        end
                    end
                end
                
                READ_MEM: begin
                    if (mem_ready) begin
                        // Fill cache line
                        cache_data[saved_address[9:2]] <= mem_read_data;
                        cache_tags[saved_address[9:5]] <= saved_address[31:10];
                        cache_valid[saved_address[9:5]] <= 1'b1;
                        state <= IDLE;
                    end
                end
                
                WRITE_MEM: begin
                    if (mem_ready) begin
                        cache_data[saved_address[9:2]] <= saved_write_data;
                        cache_tags[saved_address[9:5]] <= saved_address[31:10];
                        cache_valid[saved_address[9:5]] <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    // Memory interface
    assign mem_address = saved_address;
    assign mem_write_data = saved_write_data;
    assign mem_read_req = (state == READ_MEM);
    assign mem_write_req = (state == WRITE_MEM);

endmodule