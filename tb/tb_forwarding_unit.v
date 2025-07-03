`timescale 1ns/1ps

module tb_forwarding_unit;

    // Inputs
    reg [4:0] ex_rs1;
    reg [4:0] ex_rs2;
    reg [4:0] mem_rd;
    reg mem_reg_write;
    reg [4:0] wb_rd;
    reg wb_reg_write;
    
    // Outputs
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    
    // Instantiate the Unit Under Test (UUT)
    forwarding_unit uut (
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .mem_rd(mem_rd),
        .mem_reg_write(mem_reg_write),
        .wb_rd(wb_rd),
        .wb_reg_write(wb_reg_write),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    
    initial begin
        // Initialize Inputs
        ex_rs1 = 0;
        ex_rs2 = 0;
        mem_rd = 0;
        mem_reg_write = 0;
        wb_rd = 0;
        wb_reg_write = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test 1: No forwarding needed
        $display("Test 1: No forwarding");
        #10;
        
        // Test 2: MEM->EX forwarding for rs1
        $display("\nTest 2: MEM->EX forwarding for rs1");
        ex_rs1 = 5'h1;
        mem_rd = 5'h1;
        mem_reg_write = 1;
        #10;
        
        // Test 3: WB->EX forwarding for rs2
        $display("\nTest 3: WB->EX forwarding for rs2");
        ex_rs2 = 5'h2;
        wb_rd = 5'h2;
        wb_reg_write = 1;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_forwarding_unit.vcd");
        $dumpvars(0, tb_forwarding_unit);
    end

endmodule