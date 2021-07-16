module Memory(sram_clk, clk, rst, MEMread, MEMwrite, address, data, MEM_Result, ready);
    input sram_clk, clk, rst, MEMread, MEMwrite;
    input [31:0] address, data;
    output [31:0] MEM_Result;
    output ready;

    wire [63:0] sram_dq, sram_read_data64;
    wire[31:0] sram_write_data, sram_address ;
    wire[16:0] sram_addr;
    wire sram_wb_en, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, sram_read_en, sram_write_en;

    SRAM_Controller sram_cntrlr(sram_clk, rst, sram_write_en, sram_read_en, sram_address, sram_write_data, 
        sram_read_data64, sram_ready, sram_dq, sram_addr, sram_wb_en, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N);
    SRAM s_ram(sram_clk, rst, sram_wb_en, sram_addr, sram_dq);

    cache_controller cache_cntrlr(clk, rst, address, data, MEMread, MEMwrite,
        MEM_Result, ready, sram_address, sram_write_data, sram_write_en, sram_read_en, sram_read_data64, sram_ready);

endmodule

module SRAM(clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);
    input clk,rst,SRAM_WE_N;
    input [16:0] SRAM_ADDR;
    inout [63:0] SRAM_DQ;
    reg [31:0] memory [0:511];
    assign #30 SRAM_DQ = SRAM_WE_N ? { memory[{SRAM_ADDR[16:1], 1'b1}], memory[{SRAM_ADDR[16:1], 1'b0}] } : 64'bz;
    
    always @(posedge clk) begin
        if (~SRAM_WE_N) memory[SRAM_ADDR] <= SRAM_DQ[31:0];
    end
    
endmodule