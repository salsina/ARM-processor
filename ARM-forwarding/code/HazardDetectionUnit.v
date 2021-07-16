module HazardDetectionUnit(HI, EXE_memread_en, Rn, MEM_Dest, MEM_WB_EN, EXE_Dest, EXE_WB_EN, Src2, Two_src, src1_available, src2_available,HAZARD);
    input [3:0] Rn, MEM_Dest, EXE_Dest, Src2;
    input HI, EXE_memread_en, MEM_WB_EN, EXE_WB_EN, Two_src, src1_available, src2_available;
    output reg HAZARD;

    always @(*) begin
        HAZARD = 1'b0;
        if(EXE_memread_en) begin
            if ((Rn == EXE_Dest) || ((Src2 == EXE_Dest) && (Two_src == 1'b1))) begin
                HAZARD = 1'b1;
            end
        end
    end
endmodule

