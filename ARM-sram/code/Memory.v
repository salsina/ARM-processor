module Memory(sram_clk, clk, rst, MEMread, MEMwrite, address, data, MEM_Result, ready);
    input sram_clk, clk, rst, MEMread, MEMwrite;
    input [31:0] address, data;
    output [31:0] MEM_Result;
    output ready;

    wire[31:0] sram_dq;
    wire[16:0] sram_addr;
    wire sram_wb_en, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N;

    SRAM_Controller sram_cntrlr(sram_clk, rst, MEMwrite, MEMread, address, data, 
        MEM_Result, ready, sram_dq, sram_addr, sram_wb_en, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N);
    SRAM s_ram(sram_clk, rst, sram_wb_en, sram_addr, sram_dq);

endmodule

module SRAM(clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);
    input clk,rst,SRAM_WE_N;
    input [16:0] SRAM_ADDR;
    inout [31:0] SRAM_DQ;
    reg [31:0] memory [0:511];
    assign #30 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
    always @(posedge clk) begin
        if (~SRAM_WE_N) memory[SRAM_ADDR] <= SRAM_DQ;
    end
endmodule