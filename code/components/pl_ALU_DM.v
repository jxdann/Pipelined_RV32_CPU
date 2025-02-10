module pl_ALU_DM (
    input clk,
    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [4:0] RdE,
    input [31:0] PCPLus4E,
	 input [2:0] funct3E,
	 input [31:0] PCE,
	 input [31:0] lAuiPCE,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCPLus4M,
	 output reg [2:0] funct3M,
	 output reg [31:0] PCM,
	 output reg [31:0] lAuiPCM
);

initial begin
    RegWriteM <= 0;
    ResultSrcM <= 0;
    MemWriteM <= 0;
    ALUResultM <= 0;
    WriteDataM <= 0;
    RdM <= 0;
    PCPLus4M <= 0;
	 funct3M <= 0;
	 PCM <= 0;
	 lAuiPCM <= 0;
end

always @(posedge clk) begin
    RegWriteM <= RegWriteE;
    ResultSrcM <= ResultSrcE;
    MemWriteM <= MemWriteE;
    ALUResultM <= ALUResultE;
    WriteDataM <= WriteDataE;
    RdM <= RdE;
    PCPLus4M <= PCPLus4E;
	 funct3M <= funct3E;
	 PCM <= PCE;
	 lAuiPCM <= lAuiPCE;
end

endmodule 