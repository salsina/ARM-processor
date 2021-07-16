module MUX_21_4bit(in1, in2, s, out);
    input [3:0] in1, in2;
    input s;
    output wire [3:0] out;
    assign out = s ? in2 : in1;
endmodule