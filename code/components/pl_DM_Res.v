module pl_DM_Res (
    input clk,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [4:0] RdM,
    input [31:0] PCPlus4M,
	 input [31:0] PCM,
	 input [31:0] WriteDataM,
	 input [31:0] lAuiPCM,
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0] RdW,
    output reg [31:0] PCPlus4W,
	 output reg [31:0] PCW,
	 output reg [31:0] WriteDataW,
	 output reg [31:0] lAuiPCW
);

initial begin
    RegWriteW <= 0;
    ResultSrcW <= 0;
    ALUResultW <= 0;
    ReadDataW <= 0;
    RdW <= 0;
    PCPlus4W <= 0;
	 PCW <= 0;
	 WriteDataW <= 0;
	 lAuiPCW <= 0;
end

always @(posedge clk) begin
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
    ALUResultW <= ALUResultM;
    ReadDataW <= ReadDataM;
    RdW <= RdM;
    PCPlus4W <= PCPlus4M;
	 PCW <= PCM;
	 WriteDataW <= WriteDataM;
	 lAuiPCW <= lAuiPCM;
end
endmodule 