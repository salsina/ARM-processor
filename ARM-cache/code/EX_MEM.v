module EX_MEM(clk, rst, ready, WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, ALU_Res, Val_Rm_out, Dest_out,  
                     WB_EN_out_EXE, MEM_R_EN_out_EXE, MEM_W_EN_out_EXE, Alu_Res_out, Val_Rm_out_EXE, Dest_out_EXE);
    input clk, rst, WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, ready;
    input [31:0] ALU_Res, Val_Rm_out;
    input [3:0] Dest_out;

    output reg  WB_EN_out_EXE, MEM_R_EN_out_EXE, MEM_W_EN_out_EXE;
    output reg [31:0] Alu_Res_out, Val_Rm_out_EXE ;
    output reg [3:0] Dest_out_EXE;
    always @(posedge clk,posedge rst) begin
        if(rst)begin
            WB_EN_out_EXE <= 1'b0;
            MEM_R_EN_out_EXE <= 1'b0;
            MEM_W_EN_out_EXE <= 1'b0;
            Alu_Res_out <= 32'b0;
            Val_Rm_out_EXE <= 32'b0;
            Dest_out_EXE <= 4'b0;
        end
        else if(ready != 1'b0)begin
            WB_EN_out_EXE <= WB_EN_out;
            MEM_R_EN_out_EXE <= MEM_R_EN_out;
            MEM_W_EN_out_EXE <= MEM_W_EN_out;
            Alu_Res_out <= ALU_Res;
            Val_Rm_out_EXE <= Val_Rm_out;
            Dest_out_EXE <= Dest_out;
        end
    end
endmodule