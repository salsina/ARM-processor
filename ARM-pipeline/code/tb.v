module tb();
  reg clk, rst;

  ARM arm(clk, rst);

  initial begin
    rst = 1;
    clk = 0;
    #10;
    rst = 0;
    repeat(1000) begin
      #10 clk = ~clk;
    end
  end
  
endmodule