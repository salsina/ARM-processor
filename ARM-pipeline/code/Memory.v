module Memory(clk, rst, MEMread, MEMwrite, address, data, MEM_Result);
    input clk, rst, MEMread, MEMwrite;
    input [31:0] address, data;
    output [31:0] MEM_Result;
    
    reg [7:0] memory [0:2047];
	initial begin 
		$readmemb("memory.txt", memory);//enter the file name
	end

    wire [31:0] adr_minus_1024 = (address - 1024);
    wire [31:0] final_adr = {adr_minus_1024[31:2] ,2'b00};
    always @(posedge clk) begin

        if(MEMwrite == 1'b1)begin
            memory[final_adr + 0] <= data[7:0]; 
            memory[final_adr + 1] <= data[15:8]; 
            memory[final_adr + 2] <= data[23:16]; 
            memory[final_adr + 3] <= data[31:24]; 
            $writememb("memory.txt", memory);//enter the file name
        end
    end

    assign MEM_Result = MEMread ?  {memory[final_adr + 3], 
                                    memory[final_adr + 2],
                                    memory[final_adr + 1],
                                    memory[final_adr + 0]} : 32'b0;
endmodule