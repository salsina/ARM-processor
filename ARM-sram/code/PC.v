module PC(clk, rst, ready, inp, freeze, out);
    input clk, rst, freeze, ready; 
    input [31:0] inp;
    output reg [31:0] out;
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
	        out <= 32'b0;
	    else
            if (freeze != 1'b1 && (ready != 1'b0) ) out <= inp;
    end
endmodule 