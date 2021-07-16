module ConditionCheck(condition, StatusRegister, out);//nzcv
  input [3:0] condition, StatusRegister;
  output reg out;

  always @(*) begin
      out = 1'b0;
      case (condition) 
        4'b0000: if(StatusRegister[2] == 1'b1) out = 1'b1;
        4'b0001: if(StatusRegister[2] == 1'b0) out = 1'b1;
        4'b0010: if(StatusRegister[1] == 1'b1) out = 1'b1;
        4'b0011: if(StatusRegister[1] == 1'b0) out = 1'b1;
        4'b0100: if(StatusRegister[3] == 1'b1) out = 1'b1;
        4'b0101: if(StatusRegister[3] == 1'b0) out = 1'b1;
        4'b0110: if(StatusRegister[0] == 1'b1) out = 1'b1;
        4'b0111: if(StatusRegister[0] == 1'b0) out = 1'b1;
        4'b1000: if(StatusRegister[1] == 1'b1 && StatusRegister[2] == 1'b0) out = 1'b1;
        4'b1001: if(StatusRegister[1] == 1'b0 && StatusRegister[2] == 1'b1) out = 1'b1;
        4'b1010: if((StatusRegister[3] == 1'b1 && StatusRegister[0] == 1'b1) || (StatusRegister[3] == 1'b0 && StatusRegister[0] == 1'b0)) out = 1'b1;
        4'b1011: if((StatusRegister[3] == 1'b1 && StatusRegister[0] == 1'b0) || (StatusRegister[3] == 1'b0 && StatusRegister[0] == 1'b1)) out = 1'b1;
        4'b1100: if(StatusRegister[2] == 1'b0 && ((StatusRegister[3] == 1'b1 && StatusRegister[0] == 1'b1) || (StatusRegister[3] == 1'b0 && StatusRegister[0] == 1'b0))) out = 1'b1;
        4'b1101: if(StatusRegister[2] == 1'b1 || ((StatusRegister[3] == 1'b1 && StatusRegister[0] == 1'b0) || (StatusRegister[3] == 1'b0 && StatusRegister[0] == 1'b1))) out = 1'b1;
        4'b1110: out = 1'b1;
      endcase
  end
endmodule