module MUX_21_32bit(inp1,inp2,s,out);
    input [31:0] inp1,inp2;
    input s; 
    output wire [31:0] out;
    assign out = s ? inp2 : inp1;
endmodule