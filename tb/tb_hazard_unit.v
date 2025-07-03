`timescale 1ns/1ps

module tb_hazard_unit;

    // Inputs
    reg [4:0] id_rs1;
    reg [4:0] id_rs2;
    reg [4:0] ex_rd;
    reg ex_mem_read;
    reg [4:0] mem_rd;
    reg mem_reg_write;
    reg [4:0] wb_rd;
    reg wb_reg_write;
    reg branch_taken;
    
    // Outputs
    wire pc_stall;
    wire if_stall;
    wire id_stall;
    wire ex_stall;
    wire mem_stall;
    wire if_flush;
    wire id_flush;
    wire ex_flush;
    
    // Instantiate the Unit Under Test (UUT)
    hazard_unit uut (
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .ex_rd(ex_rd),
        .ex_mem_read(ex_mem_read),
        .mem_rd(mem_rd),
        .mem_reg_write(mem_reg_write),
        .wb_rd(wb_rd),
        .wb_reg_write(wb_reg_write),
        .branch_taken(branch_taken),
        .pc_stall(pc_stall),
        .if_stall(if_stall),
        .id_stall(id_stall),
        .ex_stall(ex_stall),
        .mem_stall(mem_stall),
        .if_flush(if_flush),
        .id_flush(id_flush),
        .ex_flush(ex_flush)
    );
    
    initial begin
        // Initialize Inputs
        id_rs1 = 0;
        id_rs2 = 0;
        ex_rd = 0;
        ex_mem_read = 0;
        mem_rd = 0;
        mem_reg_write = 0;
        wb_rd = 0;
        wb_reg_write = 0;
        branch_taken = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test 1: No hazards
        $display("Test 1: No hazards");
        #10;
        
        // Test 2: Load-use hazard
        $display("\nTest 2: Load-use hazard");
        id_rs1 = 5'h1;
        ex_rd = 5'h1;
        ex_mem_read = 1;
        #10;
        
        // Test 3: Branch taken
        $display("\nTest 3: Branch taken");
        ex_mem_read = 0;
        branch_taken = 1;
        #10;
        
        // Finish simulation
        $display("\nSimulation complete");
        $finish;
    end
    
    initial begin
        $dumpfile("tb_hazard_unit.vcd");
        $dumpvars(0, tb_hazard_unit);
    end

endmodule