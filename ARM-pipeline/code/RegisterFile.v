module RegisterFile(clk, rst, src1, src2, Dest_wb, Result_wb, writeBackEn, reg1, reg2);
    input clk, rst;
    input [3:0] src1, src2, Dest_wb;
    input [31:0] Result_wb;
    input writeBackEn;
    output [31:0] reg1, reg2;

    reg [31:0] registers [0:15] ;

    integer i;
    always @(negedge clk, posedge rst) begin
        if (rst)begin
            for (i = 0 ;i <=15; i = i + 1)
                registers[i] = i;
        end
        else begin
            if (writeBackEn) begin  
                registers[Dest_wb] <= Result_wb;   
                for (i = 0 ;i <= 15; i = i + 1)
                    $display("reg%d%d",i,registers[i]);
                $display("****************************************************");
            end
        end
    end 
    assign reg1 = registers[src1];  
    assign reg2 = registers[src2];


endmodule