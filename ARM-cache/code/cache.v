module cache(clk, rst, address, write_data, read_en, write_en, cache_call_for_write_en, read_data, hit);
    input clk, rst, read_en, write_en, cache_call_for_write_en;
    input [16:0] address;
    input [63:0] write_data;
    output hit;  
    output [31:0] read_data;

    wire Offset, hit_way0, hit_way1;
    wire [5:0] Index;
    wire [9:0] Tag;
  
    assign Offset = address[0];
    assign Index = address[6:1];
    assign Tag = address[16:7];

    reg valid_way0 [0:63];
    reg valid_way1 [0:63];

    reg [9:0] Tag_way0 [0:63];
    reg [9:0] Tag_way1 [0:63];

    reg [31:0] data_way0 [0:1][0:63];
    reg [31:0] data_way1 [0:1][0:63];

    reg LRU [0:63]; 
   
    integer row;
    initial begin
        for (row = 0; row <= 63; row = row + 1) begin
            Tag_way0[row] = 10'b0;
            Tag_way1[row] = 10'b0;
            LRU[row] = 1'b0;
            valid_way0[row] = 1'b0;
            valid_way1[row] = 1'b0;
        end
    end
        
    always @(posedge clk) begin//writing
        if (write_en) begin
            if (LRU[Index]) begin
                valid_way0[Index] <= 1'b1;
                Tag_way0[Index] <= Tag;
                data_way0[0][Index] <= write_data[31:0];
                data_way0[1][Index] <= write_data[63:32];
            end

            else begin
                valid_way1[Index] <= 1'b1;
                Tag_way1[Index] <= Tag;
                data_way1[0][Index] <= write_data[31:0];
                data_way1[1][Index] <= write_data[63:32];
            end
        end
    end
  
    always @(posedge clk) begin//data not valid
        if (cache_call_for_write_en == 1'b1 && hit == 1'b1 && hit_way0 == 1'b1) 
            {LRU[Index], valid_way0[Index]} <= 2'b10;

        else if(cache_call_for_write_en == 1'b1 && hit == 1'b1 && hit_way1 == 1'b1) 
            {LRU[Index], valid_way1[Index]} <= 2'b00;
    end

    always @(posedge clk) begin//setting the LRU
        if (read_en == 1'b1 && hit == 1'b1)
            LRU[Index] <= ~hit_way0 ; 
    end

    assign hit_way0 = ((valid_way0[Index] == 1'b1) && (Tag == Tag_way0[Index])) ?  1'b1 : 1'b0;
    assign hit_way1 = ((valid_way1[Index] == 1'b1) && (Tag == Tag_way1[Index])) ?  1'b1 : 1'b0;
    or hit_or(hit, hit_way0, hit_way1);

    MUX_21_32bit m(data_way1[Offset][Index], data_way0[Offset][Index], hit_way0, read_data);

endmodule