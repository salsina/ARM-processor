module forwardingUnit(src1, src2, MEM_dest, WB_dest, MEM_WB_en, WB_WB_en, sel_src1, sel_src2, ignore_hazard);
    input [3:0] src1, src2, MEM_dest, WB_dest;
    input MEM_WB_en, WB_WB_en;
    output reg [1:0] sel_src1, sel_src2;
    output reg ignore_hazard;

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

    // always@(*) begin
	// 	sel_src1 = 2'b0;
	// 	sel_src2 = 2'b0;
    //     ignore_hazard = 1'b0;
    //     if (WB_WB_en) begin
    //         if (WB_dest == src1) begin
    //             sel_src1 = 2'b10; //2'b10
    //             ignore_hazard = 1'b1;
    //         end
            
    //         if (WB_dest == src2) begin
    //             sel_src2 = 2'b10; //2/b10
    //             ignore_hazard = 1'b1;
    //         end
    //     end

    //     if (MEM_WB_en) begin
    //         if (MEM_dest == src1) begin
    //             sel_src1 = 2'b01;
    //             ignore_hazard = 1'b1;
    //         end
            
    //         if (MEM_dest == src2) begin
    //             sel_src2 = 2'b01;
    //             ignore_hazard = 1'b1;
    //         end
    //     end
	// end

endmodule