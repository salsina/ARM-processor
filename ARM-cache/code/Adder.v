module Adder(A,B,result);
    input[31:0] A,B;
    output reg [31:0] result;
    always@(A,B)begin
        result = A + B;
    end
endmodule