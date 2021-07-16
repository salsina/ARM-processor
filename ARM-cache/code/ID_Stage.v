module ID_Stage(clk, rst, freeze, pc, instruction, reg_file_wb_address, reg_file_wb_data, reg_file_enable, status_register, 
		pc_out, reg_file_src1, reg_file_src2, reg_file_dst, val_Rn, val_Rm, signed_immediate, shifter_operand, EX_command_out,
		mem_read_out, mem_write_out, WB_en_out, Imm_out, B_out, SR_update_out, Two_src, has_src1, has_src2);
	
	input clk, rst, freeze, reg_file_enable;
	input [3:0] reg_file_wb_address, status_register;
	input [31:0] pc, instruction, reg_file_wb_data;

	output mem_read_out, mem_write_out, WB_en_out, Imm_out, B_out, SR_update_out, Two_src, has_src1, has_src2;
	output [3:0] reg_file_src1, reg_file_src2, reg_file_dst, EX_command_out;
	output [11:0] shifter_operand;
	output [23:0] signed_immediate;
	output [31:0] pc_out, val_Rn, val_Rm;

	wire has_src2, has_src1;
	wire mem_write, condition_state;
	wire [3:0] EX_command;
	wire [8:0] control_unit_mux_out;

	assign Two_src = has_src1 | has_src2;
	assign pc_out = pc;
	assign shifter_operand = instruction[11:0];
	assign reg_file_dst = instruction[15:12];
	assign reg_file_src1 = instruction[19:16];
	assign signed_immediate = instruction[23:0];
	assign Imm_out = instruction[25];
	assign has_src2 = (~instruction[25]) | mem_write;

	MUX_21_4bit MUX_before_Reg_File (instruction[3:0], instruction[15:12], mem_write, reg_file_src2);

	RegisterFile register_file(clk, rst, reg_file_src1, reg_file_src2, reg_file_wb_address, reg_file_wb_data, reg_file_enable, 
									val_Rn, val_Rm);

	wire [9:0] controller_out;
	Controller cntrlr (instruction[20], instruction[27:26], instruction[24:21], controller_out);
	assign mem_write = controller_out[4];

	assign has_src1 = controller_out[0];
	
	assign control_unit_mux_enable = (~condition_state) | freeze;
	MUX_21_9bit MUX_after_Controller (controller_out[9:1], 9'b0, control_unit_mux_enable, control_unit_mux_out);

	ConditionCheck cond_check (instruction[31:28], status_register, condition_state);

	assign EX_command_out = control_unit_mux_out[8:5];
	assign mem_read_out = control_unit_mux_out[4];
	assign mem_write_out = control_unit_mux_out[3];
	assign WB_en_out = control_unit_mux_out[2];
	assign B_out = control_unit_mux_out[1];
	assign SR_update_out = control_unit_mux_out[0];

endmodule
