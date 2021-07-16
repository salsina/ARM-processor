module MEM_WB(clk, rst, WB_EN_out_EXE, MEM_R_EN_out_EXE, Alu_Res_out, DataMem_out, Dest_out_EXE, 
                    WB_EN_out_MEM, MEM_R_EN_out_MEM, Alu_Res_out_MEM, DataMem_out_MEM, Dest_out_MEM);

    input clk, rst, WB_EN_out_EXE, MEM_R_EN_out_EXE;
    input [31:0] Alu_Res_out, DataMem_out;
    input [3:0] Dest_out_EXE;

    output reg WB_EN_out_MEM, MEM_R_EN_out_MEM;
    output reg [31:0] Alu_Res_out_MEM, DataMem_out_MEM;
    output reg [3:0] Dest_out_MEM;

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            WB_EN_out_MEM <= 1'b0;
            MEM_R_EN_out_MEM <= 1'b0;
            Alu_Res_out_MEM <= 32'b0;
            DataMem_out_MEM <= 32'b0;
            Dest_out_MEM <= 4'b0;
        end
        else begin
            WB_EN_out_MEM <= WB_EN_out_EXE;
            MEM_R_EN_out_MEM <= MEM_R_EN_out_EXE;
            Alu_Res_out_MEM <= Alu_Res_out;
            DataMem_out_MEM <= DataMem_out;
            Dest_out_MEM <= Dest_out_EXE;
        end
    end
endmodule