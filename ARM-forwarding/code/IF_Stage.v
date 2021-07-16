module IF_Stage(clk, rst, freeze, branch_taken, branch_addr, pc, instruction);
  input clk, rst, freeze, branch_taken;
  input [31:0] branch_addr; 
  output [31:0] pc, instruction;

  wire [31:0] pc_out, mux_out;
  wire x;

  reg[3:0] counter;
  always @(*) begin
    if(rst) counter = 0;
    else if(branch_taken)begin
      counter = counter + 1;
    end
  end

  assign x = (counter > 11 && branch_taken)? 1'b0 : branch_taken;
  
  MUX_21_32bit mux_before_pc (pc, branch_addr, x, mux_out);

  PC pc_indtance (clk, rst, mux_out, freeze, pc_out);

  Adder adder (32'd1, pc_out, pc);
  
  Instruction_memory inst_mem (pc_out, instruction);
  
endmodule