module tb();
  reg sram_clk, clk, rst;

  ARM arm(sram_clk, clk, rst);

  initial begin
    rst = 1;
    clk = 0;
    #20;
    rst = 0;
    repeat(1000) begin
      #20 clk = ~clk;
    end
  end
  
  initial begin
    rst = 1;
    sram_clk = 0;
    #40;
    rst = 0;
    repeat(500) begin
      #40 sram_clk = ~sram_clk;
    end
  end

endmodule