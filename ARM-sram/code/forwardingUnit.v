module forwardingUnit(src1, src2, MEM_dest, WB_dest, MEM_WB_en, WB_WB_en, sel_src1, sel_src2);
    input [3:0] src1, src2, MEM_dest, WB_dest;
    input MEM_WB_en, WB_WB_en;
    output reg [1:0] sel_src1, sel_src2;

    always @(*) begin
        sel_src1 = 2'b00;
        sel_src2 = 2'b00;
        if ((src1 == MEM_dest) && (MEM_WB_en == 1'b1))
            sel_src1 = 2'b01;
        else if ((src1 == WB_dest) && (WB_WB_en == 1'b1))
            sel_src1 = 2'b10;
        if ((src2 == MEM_dest) && (MEM_WB_en == 1'b1))
            sel_src2 = 2'b01;
        else if ((src2 == WB_dest) && (WB_WB_en == 1'b1))
            sel_src2 = 2'b10;
    end
endmodule