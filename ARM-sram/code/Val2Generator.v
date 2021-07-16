module Val2Generator(memrw, Val_Rm, imm, Shift_operand, out);

    input memrw, imm;
    input[31:0] Val_Rm;
    input[11:0] Shift_operand;
    output[31:0] out;
    reg[31:0] tempOut;
    wire[1:0] shift_mode;
    assign shift_mode = Shift_operand[6:5];
    
    reg[31:0] rotate_shift_result;
 //   rotate_shift_result[7:0] = Shift_operand[7:0];
    reg[31:0] immshift_rotate_shift_result;
   
    integer i;
    integer j;

    always @(*) begin
      rotate_shift_result = Shift_operand[7:0];
      immshift_rotate_shift_result = Val_Rm;

        for (i = 0; i < (Shift_operand[11:8]); i = i + 1) begin
            rotate_shift_result = {rotate_shift_result[1:0], rotate_shift_result[31:2]};
        end

        for (j = 0; j < (Shift_operand[11:8]); j = j + 1) begin
            immshift_rotate_shift_result = {immshift_rotate_shift_result[0], immshift_rotate_shift_result[31:1]};
        end

        tempOut = memrw ? Shift_operand : (
            imm == 1'b1 ? rotate_shift_result : (
                imm == 1'b0 && Shift_operand[4] == 1'b0 ? (
                    shift_mode == 2'b00 ? Val_Rm << Shift_operand[11:7] :
                    shift_mode == 2'b01 ? Val_Rm >> Shift_operand[11:7] :
                    shift_mode == 2'b10 ? Val_Rm >>> Shift_operand[11:7] : immshift_rotate_shift_result
                ) : 32'b0
            )
        );
    end

    assign out = tempOut;

endmodule