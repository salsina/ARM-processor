module EXE_Stage(clk, rst, pc, signed_immediate, EX_command, SR, shifter_operand, dst, mem_R, mem_W, imm, WB_en, B, val_Rn, val_Rm,
  dst_out, SR_out, ALU_res, val_Rm_out, branch_addr, mem_R_out, mem_W_out, WB_en_out, B_out);

  input clk, rst, mem_R, mem_W, imm, WB_en, B;
  input [31:0] pc, val_Rn, val_Rm;
  input  [23:0] signed_immediate;
  input  [3:0] EX_command, SR, dst;
  input  [11:0] shifter_operand;

  output [3:0] dst_out, SR_out;
  output [31:0] ALU_res, val_Rm_out, branch_addr;
  output mem_R_out, mem_W_out, WB_en_out, B_out;

  wire [31:0] val2;
  wire Val2Gen_sel;

  assign Val2Gen_sel = mem_R | mem_W;
  
  Val2Generator Val2_Gen(Val2Gen_sel, val_Rm, imm, shifter_operand, val2);

  ALU ALU_Inst(val_Rn, val2, EX_command, SR[1], ALU_res, SR_out);

  Adder Adder_Inst(pc, {(signed_immediate[23] ? 8'b11111111: 8'b0 ), signed_immediate}, branch_addr);

  assign dst_out = dst;
	assign mem_R_out = mem_R;
	assign mem_W_out = mem_W;
  assign WB_en_out = WB_en;
  assign B_out = B;
  assign val_Rm_out = val_Rm;

endmodule
