module Controller(S, mode, op_code, out);
    input S;
    input [1:0] mode;
    input [3:0] op_code;
    output [9:0] out;

    reg[9:0] ans;

    always @(*) begin
        ans[5:2] = 4'b0;
        case (mode)
            2'b01: begin
                if(S == 1'b1)begin
                    ans[9:6] = 4'b1010;
                    ans[5] = 1;
                    ans[3] = 1;
                end
                else if(S == 1'b0)begin
                    ans[9:6] = 4'b1010;
                    ans[4] = 1;
                end
            end

            2'b00: begin
                case (op_code)
                    4'b1101: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0001;
                    end

                    4'b1111: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b1001;
                    end

                    4'b0100: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0010;
                    end

                    4'b0101: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0011;
                    end

                    4'b0010: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0100;
                    end

                    4'b0110: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0101;
                    end
                    4'b0000: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0110;
                    end

                    4'b1100: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b0111;
                    end

                    4'b0001: begin
                        ans[3] = 1;
                        ans[9:6] = 4'b1000;
                    end

                    4'b1010: begin
                        ans[9:6] = 4'b1100;
                    end

                    4'b1000: begin
                        ans[9:6] = 4'b1110;
                    end
                endcase
            end

            2'b10: begin
                ans[2] = 1;
            end
        endcase
    end

    assign out[1] = S;
    assign out[0] = ((ans[9:6] == 4'b0001) ||
                       (ans[9:6] == 4'b1001) || 
                            ans[2]) ? 1'b0 : 1'b1;

    assign out[9:2] = ans[9:2];
endmodule
