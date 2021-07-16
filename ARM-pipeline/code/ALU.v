module ALU(Val1, Val2, EXE_CMD, Carry_in, Res, StatusBits);//nzcv
    input [31:0] Val1, Val2;
    input [3:0] EXE_CMD;
    input Carry_in;
    output reg[31:0] Res;
    output [3:0] StatusBits;

    reg V, C;
    wire N, Z;

    assign N = Res[31];
    assign Z = (Res == 32'b0 )? 1'b1: 1'b0;
    assign StatusBits = {N, Z, C, V};

    always @(*) begin
        V = 1'b0;
        C = 1'b0;
        case (EXE_CMD)
            4'b0001: begin//MOV
                Res = Val2;
            end
            4'b0010: begin//SUM
                {C, Res} = Val1 + Val2;
                V = ((Val1[31] == Val2[31]) & (Res[31] != Val1[31]));
            end
            4'b0011: begin// SUM + CARRY
                {C, Res} = Val1 + Val2 + Carry_in;
                V = ((Val1[31] == Val2[31]) & (Res[31] != Val1[31]));
            end
            4'b0100: begin//SUB
                {C, Res} = Val1 - Val2;
                V = ((Val1[31]== ~Val2[31]) & (Res[31] != Val1[31]));
            end
            4'b0101: begin//SUB - ~CARRY
                {C, Res} = Val1 - Val2 - 1 + Carry_in;
                V = ((Val1[31] == Val2[31]) & (Res[31] != Val1[31]));
            end
            4'b0110: begin//AND
                Res = Val1 & Val2;
            end
            4'b0111: begin//OR
                Res = Val1 | Val2;
            end
            4'b1000: begin//XOR
                Res = Val1 ^ Val2;
            end
            4'b1001: begin//MVN
                Res = ~Val2;
            end
            4'b1100: begin//cmp
                {C, Res} = {Val1[31], {Val1}} - {Val2[31], {Val2}};
                V = ((Val1[31] == ~Val2[31]) & (Res[31] != Val1[31]));
            end
            4'b1110: begin//tst
                Res = Val1 & Val2;
            end
            4'b1010: begin//ldr
                Res = Val1 + Val2;
            end
            4'b1010: begin//str
                Res = Val1 + Val2;
            end

        endcase
    end

endmodule