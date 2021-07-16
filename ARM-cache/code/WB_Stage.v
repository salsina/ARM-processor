module WB_Stage(clk, rst, Alu_result, Mem_Result, MEM_R_EN, out);
    input clk, rst, MEM_R_EN;
    input [31:0] Alu_result, Mem_Result;
    output [31:0] out;

    MUX_21_32bit mux1(Alu_result, Mem_Result, MEM_R_EN, out);
endmodule

