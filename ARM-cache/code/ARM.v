module ARM(sram_clk, clk, rst);
  input clk, rst, sram_clk;

  wire [31:0] IF_PcOut, IF_InstructionOut, branch_addr, MEM_WB_ALUresult, MEM_WB_MemOut, IF_ID_PcOut, IF_ID_InstructionOut,
    ID_PcOut, ID_val_Rn, ID_val_Rm, WB_Value,
    ID_reg_pc_out, ID_reg_val_Rn_out, ID_reg_val_Rm_out,
    EXE_MEM_val_Rm_out, EXE_MEM_ALU_res_out, EXE_MEM_instruction_out, MEM_ALU_res_out, EXE_instruction_out, EXE_val_Rm_out, ALU_res, MEM_mem_out;
	
  wire [23:0] ID_signed_immediate, ID_reg_signed_immediate_out;
	
  wire [11:0] ID_shifter_operand, ID_reg_shifter_operand_out;
  
  wire [3:0] ID_reg_file_dst, ID_reg_file_src1, ID_reg_file_src2, ID_EX_command_out, status, MEM_WB_dst_out, 
    ID_reg_reg_file_dst_out, ID_reg_SR_out, ID_reg_EX_command_out, ID_reg_reg_file_src1, ID_reg_reg_file_src2,
    EXE_MEM_dst_out, EXE_reg_file_dst_out, EXE_SR_out;

  wire [1:0] EXE_src1_sel, EXE_src2_sel;
  assign EXE_src1_sel = 2'b0;
  assign EXE_src2_sel = 2'b0;
  //------------------------------------------------------------------------------------------ 
  IF_Stage  IF (clk, rst, ready, hazard_detected, EXE_B_out, branch_addr, 
                              IF_PcOut, IF_InstructionOut);

  IF_ID  IFID (clk, rst, ready, IF_PcOut, IF_InstructionOut, EXE_B_out, hazard_detected, 
    IF_ID_PcOut, IF_ID_InstructionOut);

  //------------------------------------------------------------------------------------------ 
  HazardDetectionUnit HazardDetect(
    EXE_mem_read_out, ID_reg_file_src1, EXE_MEM_dst_out, EXE_MEM_WB_en_out, ID_reg_reg_file_dst_out, ID_reg_WB_en_out, ID_reg_file_src2, Two_src, src1_available, src2_available,
    hazard_detected);
  // HazardDetectionUnit HazardDetect(
  //   ID_reg_file_src1, EXE_MEM_dst_out, EXE_MEM_WB_en_out, ID_reg_reg_file_dst_out, ID_reg_WB_en_out, ID_reg_file_src2, Two_src, 
  //   hazard_detected);

  ID_Stage ID(clk, rst, hazard_detected, IF_ID_PcOut, IF_ID_InstructionOut, MEM_WB_dst_out, WB_Value, MEM_WB_WB_en_out, status, 
    
    ID_PcOut, ID_reg_file_src1, ID_reg_file_src2, ID_reg_file_dst, ID_val_Rn, ID_val_Rm, ID_signed_immediate, 
    ID_shifter_operand, ID_EX_command_out,ID_mem_read_out, ID_mem_write_out, ID_WB_en_out, ID_Imm_out, ID_B_out, 
    ID_SR_update_out, Two_src, src1_available, src2_available); 
  
  ID_EX IDEX(clk, rst, ready, ID_WB_en_out, ID_mem_read_out, ID_mem_write_out, ID_EX_command_out, ID_B_out, 
    ID_SR_update_out, ID_PcOut, ID_val_Rn, ID_val_Rm, ID_Imm_out, ID_shifter_operand, ID_signed_immediate, 
    ID_reg_file_dst, EXE_B_out, status, ID_reg_file_src1,ID_reg_file_src2,
    
    ID_reg_reg_file_src1, ID_reg_reg_file_src2, ID_reg_SR_out, ID_reg_WB_en_out, ID_reg_mem_read_out, ID_reg_mem_write_out,
    ID_reg_EX_command_out, ID_reg_B_out, ID_reg_SR_update_out, ID_reg_pc_out, ID_reg_val_Rn_out, ID_reg_val_Rm_out, ID_reg_Imm_out, ID_reg_shifter_operand_out,
    ID_reg_signed_immediate_out, ID_reg_reg_file_dst_out);

  //------------------------------------------------------------------------------------------ 
  EXE_Stage EXE(clk, rst, ID_reg_pc_out, ID_reg_signed_immediate_out, ID_reg_EX_command_out, ID_reg_SR_out, ID_reg_shifter_operand_out, ID_reg_reg_file_dst_out,
    ID_reg_mem_read_out, ID_reg_mem_write_out, ID_reg_Imm_out, ID_reg_WB_en_out, ID_reg_B_out, ID_reg_val_Rn_out, ID_reg_val_Rm_out, EXE_src1_sel, EXE_src2_sel, EXE_MEM_ALU_res_out, WB_Value,
    
    EXE_reg_file_dst_out, EXE_SR_out, ALU_res, EXE_val_Rm_out, branch_addr, EXE_mem_read_out, EXE_mem_write_out, EXE_WB_en_out, EXE_B_out);

  EX_MEM EXMEM(clk, rst, ready, EXE_WB_en_out, EXE_mem_read_out, EXE_mem_write_out, ALU_res,
    EXE_val_Rm_out, EXE_reg_file_dst_out, 

    EXE_MEM_WB_en_out, EXE_MEM_mem_read_out, EXE_MEM_mem_write_out,
    EXE_MEM_ALU_res_out, EXE_MEM_val_Rm_out, EXE_MEM_dst_out);
  
  StatusRegister StatusReg(clk, rst, ID_reg_SR_update_out, EXE_SR_out, status);

  forwardingUnit FU(ID_reg_reg_file_src1, ID_reg_reg_file_src2, EXE_MEM_dst_out, MEM_WB_dst_out, EXE_MEM_WB_en_out, MEM_WB_WB_en_out,
                    EXE_src1_sel, EXE_src2_sel);

  //------------------------------------------------------------------------------------------ 
  Memory mem(sram_clk, clk, rst, EXE_MEM_mem_read_out, EXE_MEM_mem_write_out, EXE_MEM_ALU_res_out, EXE_MEM_val_Rm_out, MEM_mem_out, ready);

  MEM_WB MEMWB(clk, rst, ready, EXE_MEM_WB_en_out, EXE_MEM_mem_read_out, EXE_MEM_ALU_res_out, MEM_mem_out, EXE_MEM_dst_out,
    MEM_WB_WB_en_out, MEM_WB_read_out, MEM_WB_ALUresult, MEM_WB_MemOut, MEM_WB_dst_out);

  //------------------------------------------------------------------------------------------ 
  WB_Stage WB(clk, rst, MEM_WB_ALUresult, MEM_WB_MemOut, MEM_WB_read_out, WB_Value);

endmodule
