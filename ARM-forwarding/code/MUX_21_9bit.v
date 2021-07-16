module MUX_21_9bit(in1, in2, s, out);
    input [8:0] in1, in2;
    input s;
    output wire [8:0] out;
    assign out = s ? in2 : in1;
endmodule