module IF_ID(clk, rst, ready, pc, instruction, flush, freeze, pc_out, instruction_out);
  input clk, rst, flush, freeze,ready;
  input [31:0] pc, instruction;
  output reg[31:0] pc_out, instruction_out;
  
  always @(posedge clk, posedge rst) begin
      if (rst == 1'b1) begin
          pc_out <= 32'b0;
          instruction_out <= 32'b0;
      end
      else if (flush == 1'b1)begin
          pc_out <= 32'b0;
          instruction_out <= 32'b0;
      end
      else begin
          if ((freeze != 1'b1) && (ready != 1'b0))begin
              pc_out <= pc;
              instruction_out <= instruction;
          end
      end
  end
endmodule