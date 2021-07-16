module cache_controller(clk, rst, address, writeData, MEM_R_EN, MEM_W_EN,
     rdata, ready, sram_address, sram_write_data, sram_write_en, sram_read_en, sram_read_data, sram_ready);
  
  input clk, rst, MEM_R_EN, MEM_W_EN, sram_ready;
  input [31:0] address, writeData;
  input [63:0] sram_read_data;

  output ready;    
  output reg sram_write_en, sram_read_en;
  output reg [31:0] sram_write_data;
  output reg [31:0] rdata, sram_address;

  wire cache_W_EN, cache_R_EN, cache_call_for_write, cache_hit;
  wire [16:0] CacheAddr;
  wire [31:0] addr_minus_1024, readData_cache;    

  reg [1:0] ps, ns;
 
  parameter [1:0] IDLE = 2'b00, Sram_R_Cache_W = 2'b01, Sram_W = 2'b10;

  always @(posedge clk, posedge rst) begin // set state
      if (rst == 1'b1) ps <= 2'b0;
      else ps <= ns;
  end

  always @(*) begin //set ns
    ns = ps;
    case(ps)
      IDLE: begin
          if(MEM_R_EN && ~cache_hit) 
            ns = Sram_R_Cache_W;
          else if(MEM_W_EN)
            ns = Sram_W;
      end

      Sram_R_Cache_W: if (sram_ready) ns = IDLE;        

      Sram_W: if (sram_ready) ns = IDLE;        

    endcase
  end

  always @(*) begin// set signals
    rdata = 32'bz;
    sram_address = 64'bz;
    sram_write_data = 64'bz;
    sram_write_en = 1'b0;
    sram_read_en = 1'b0;

    case (ps)
      IDLE: if (cache_hit) rdata = readData_cache;        

      Sram_R_Cache_W: begin
        sram_address = address;
        sram_read_en = 1'b1;

        if (sram_ready) begin
          if (CacheAddr[0]) // offset
            rdata = sram_read_data[63:32];
          else 
            rdata = sram_read_data[31:0];
        end 
      
      end

      Sram_W:begin
        sram_address = address;
        sram_write_data = writeData;
        sram_write_en = 1'b1;
      end

    endcase
  end

  assign ready = (ns == IDLE) ? 1'b1 : 1'b0;
  assign cache_R_EN = (ps == IDLE) ? 1'b1 : 1'b0;
  assign cache_W_EN = ((ps == Sram_R_Cache_W) && (sram_ready == 1'b1)) ? 1'b1 : 1'b0;
  assign cache_call_for_write = ((ps == IDLE) && (ns == Sram_W)) ? 1'b1 : 1'b0;

  assign addr_minus_1024 = address - 1024;
  assign CacheAddr = addr_minus_1024[17:2];
  cache che(clk, rst, CacheAddr, sram_read_data, cache_R_EN, cache_W_EN, cache_call_for_write, readData_cache, cache_hit);
      
endmodule