module ID_EX(clk, rst, ready, WB_EN, MEM_R_EN, MEM_W_EN, EXE_CMD, B, S, PC, Val_Rn, Val_Rm, imm, shift_operand, Signed_imm_24, Dest, flush, SR_in, reg_src1, reg_src2,
                reg_src1_out, reg_src2_out, SR_out, WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, EXE_CMD_out, B_out, S_out, PC_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, Signed_imm_24_out, Dest_out);
    input clk, rst, flush, WB_EN, MEM_R_EN, MEM_W_EN, B, S, imm, ready;
    input [3:0] EXE_CMD, Dest, SR_in, reg_src1, reg_src2;
    input [11:0] shift_operand;
    input [23:0] Signed_imm_24;
    input [31:0] PC, Val_Rn, Val_Rm;

    output reg WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, imm_out;
    output reg [3:0] EXE_CMD_out, Dest_out, SR_out, reg_src1_out, reg_src2_out;
    output reg [11:0] shift_operand_out;
    output reg [23:0] Signed_imm_24_out;
    output reg [31:0] PC_out, Val_Rn_out, Val_Rm_out;

    always @(posedge clk,posedge rst) begin
        if(rst == 1'b1 ) begin
            WB_EN_out <= 1'b0;
            MEM_R_EN_out <= 1'b0;
            MEM_W_EN_out <= 1'b0;
            B_out <= 1'b0;
            S_out <= 1'b0;
            imm_out <= 1'b0;
            EXE_CMD_out <= 4'b0;
            Dest_out <= 4'b0;
            shift_operand_out <= 12'b0;
            Signed_imm_24_out <= 24'b0;
            PC_out <= 32'b0;
            Val_Rn_out <= 32'b0;
            Val_Rm_out <= 32'b0;

            SR_out <= 4'b0;
            reg_src1_out <= 32'b0;
            reg_src2_out <= 32'b0;
        end
		  else if(flush == 1'b1)begin
            WB_EN_out <= 1'b0;
            MEM_R_EN_out <= 1'b0;
            MEM_W_EN_out <= 1'b0;
            B_out <= 1'b0;
            S_out <= 1'b0;
            imm_out <= 1'b0;
            EXE_CMD_out <= 4'b0;
            Dest_out <= 4'b0;
            shift_operand_out <= 12'b0;
            Signed_imm_24_out <= 24'b0;
            PC_out <= 32'b0;
            Val_Rn_out <= 32'b0;
            Val_Rm_out <= 32'b0;

            SR_out <= 4'b0;
            reg_src1_out <= 32'b0;
            reg_src2_out <= 32'b0;
		  end
        else if (ready != 1'b0)begin

            WB_EN_out <= WB_EN;
            MEM_R_EN_out <= MEM_R_EN;
            MEM_W_EN_out <= MEM_W_EN;
            B_out <= B;
            S_out <= S;
            imm_out <= imm;
            EXE_CMD_out <= EXE_CMD;
            Dest_out <= Dest;
            shift_operand_out <= shift_operand;
            Signed_imm_24_out <= Signed_imm_24;
            PC_out <= PC;
            Val_Rn_out <= Val_Rn;
            Val_Rm_out <= Val_Rm;

            SR_out <= SR_in;
            reg_src1_out <= reg_src1;
            reg_src2_out <= reg_src2;

        end
    end
endmodule