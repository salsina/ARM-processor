module PC(clk, rst, inp, freeze, out);
    input clk, rst, freeze; 
    input [31:0] inp;
    output reg [31:0] out;
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
	        out <= 32'b0;
	    else
            if (freeze != 1'b1) out <= inp;
    end
endmodule 