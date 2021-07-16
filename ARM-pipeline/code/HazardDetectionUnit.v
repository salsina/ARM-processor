module HazardDetectionUnit(Rn, MEM_Dest, MEM_WB_EN, EXE_Dest, EXE_WB_EN, Src2, Two_src, HAZARD);
    input [3:0] Rn, MEM_Dest, EXE_Dest, Src2;
    input MEM_WB_EN, EXE_WB_EN, Two_src;
    output reg HAZARD;

    always @(*) begin
        HAZARD = 1'b0;
        if(MEM_WB_EN == 1'b1)begin
            if(Two_src == 1'b1) begin
                if(MEM_Dest == Rn || MEM_Dest == Src2)
                    HAZARD = 1'b1;
            end
            else begin
                if(MEM_Dest == Rn)
                    HAZARD = 1'b1;
            end
        end

        if(EXE_WB_EN == 1'b1)begin
            if(Two_src == 1'b1)begin
                if(EXE_Dest == Rn || EXE_Dest == Src2)
                    HAZARD = 1'b1;
            end
            else begin
                if(EXE_Dest == Rn)
                    HAZARD = 1'b1;
            end
        end
    end

endmodule