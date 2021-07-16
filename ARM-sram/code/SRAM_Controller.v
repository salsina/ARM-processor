module SRAM_Controller (clk, rst, write_en, read_en, address, writeData,
    readData, ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N);
    
    input clk, rst, write_en, read_en;
    input[31:0] address, writeData;
    
    output [31:0] readData;
    output ready, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    inout[31:0] SRAM_DQ;
    output [16:0] SRAM_ADDR;

    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;

    assign SRAM_DQ = (write_en == 1'b1) ? writeData : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
    assign SRAM_ADDR = address[18 : 2];
    assign SRAM_WE_N = (write_en == 1'b0) ? 1'b1 : 1'b0;

    assign read_data = SRAM_DQ;

    reg count_EN;
	reg [1:0] ps, ns;
    reg [2:0] counter;

    parameter [1:0] IDLE = 2'b00, READ_STALL = 2'b01, WRITE_STALL = 2'b10;

    always @(posedge clk, posedge rst) begin // counter
        if (rst)
            counter <= 3'b0;
        else if (count_EN) begin
            if (counter == 6)
                counter <= 3'b0;
            else
                counter <= counter + 1;
        end
    end

    always @(posedge clk, posedge rst) begin // set state
        if (rst == 1'b1) ps <= 3'b0;
        else ps <= ns;
    end

    always @(ps) begin // set count enable
        if(ps != IDLE) count_EN = 1'b1;
        else count_EN = 1'b0;
    end

    always @(*) begin // find next state
        case (ps)
            IDLE: 
                ns = (read_en == 1'b1) ? READ_STALL : ((write_en == 1'b1) ? WRITE_STALL : IDLE);

            READ_STALL: 
                ns = (counter != 5) ? READ_STALL : IDLE;

            WRITE_STALL: 
                ns = (counter != 5) ? WRITE_STALL : IDLE;

        endcase
    end
                        
    assign ready = ((read_en == 1'b0) && (write_en == 1'b0)) ? 1'b1 : ((counter != 5) ? 1'b0 : 1'b1);

endmodule