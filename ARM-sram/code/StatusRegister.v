module StatusRegister(clk, rst, S, StatusBits, SR_out);
    input clk, rst, S;
    input [3:0] StatusBits;
    output reg [3:0] SR_out;
    
    always @(negedge clk, posedge rst) begin
        if(rst)
            SR_out <= 4'b0;
        else if(S == 1'b1) SR_out <= StatusBits;
    end
endmodule