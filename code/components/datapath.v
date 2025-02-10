
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         MemWrite,
    input         ALUSrc, RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    input         Branch, Jump, Jalr,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,                      //This is actaully ResultW
    output [31:0] PCW, ALUResultW, WriteDataW,
    output [31:0] InstrD,
	 output [2:0]  funct3M,
    output MemWriteM
);

wire [31:0] PCNext,PCM, PCJalr, PCPlus4, PCTarget, AuiPC, lAuiPC;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;
wire Zero, TakeBranch;
wire funct7b5;
wire [31:0] PCD, PCPlus4D;

wire [1:0] ForwardAE, ForwardBE;
wire [1:0] ResultSrcE, ImmSrcE, ResultSrcM, ResultSrcW;
wire [3:0] ALUControlE;
wire [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE, WriteDataE;
wire [31:0] ALUResultM, WriteDataM, PCPlus4M;
wire [31:0] ReadDataW, PCPlus4W;
wire [4:0] Rs1E, Rs2E, RdE, RdM, RdW;
wire [19:0] auiImmE; 
wire BranchE, JumpE, JalrE;
wire [31:0] SrcAE, SrcBE;
wire [2:0] funct3E;
wire [31:0] lAuiPCW, lAuiPCM;

wire PCSrc = ((BranchE & TakeBranch) || JumpE || JalrE) ? 1'b1 : 1'b0;

// next PC logic
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 #(32)     jalrmux (PCNext, ALUResult, JalrE, PCJalr);
reset_ff #(32) pcreg(clk, reset, StallF, PCJalr, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);

// Pipeline Register 1 -> Fetch | Decode

pl_reg_fd plfd (clk, StallD, FlushD, Instr, PC, PCPlus4, InstrD, PCD, PCPlus4D);

adder          pcaddbranch(PCE, ImmExtE, PCTarget);

// register file logic
reg_file       rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, Result, SrcA, WriteData);
imm_extend     ext (InstrD[31:7], ImmSrc, ImmExt); //ImmSrc is ImmSrcD and ImmExt is ImmExtD

// Pipeline Register 2 -> Decode | Execute

pl_RfE_ALU  plRALU (clk, FlushE, ResultSrc, MemWrite, ALUSrc, RegWrite, Branch, Jump, Jalr, ImmSrc, ALUControl,
            SrcA, WriteData, PCD, PCPlus4D, ImmExt, InstrD[19:15], InstrD[24:20], InstrD[11:7], InstrD[30], InstrD[14:12], InstrD[31:12], InstrD[5],
            ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, BranchE, JumpE, JalrE, ImmSrcE, ALUControlE, funct7b5E, funct3E, 
            RD1E, RD2E, PCE, PCPlus4E, ImmExtE, Rs1E, Rs2E, RdE,auiImmE, lauiSelE);

// ALU logic

mux3 #(32) SrcAMux (RD1E, Result, ALUResultM, ForwardAE, SrcAE);

mux3 #(32) WDEMux (RD2E, Result, ALUResultM, ForwardBE, WriteDataE);

mux2 #(32)     srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
alu            alu (SrcAE, SrcBE, ALUControlE, funct7b5E, ALUResult, Zero); //ALUResult is ALUResultE
adder #(32)    auipcadder ({auiImmE, 12'b0}, PCE, AuiPC);
mux2 #(32)     lauipcmux (AuiPC, {auiImmE, 12'b0}, lauiSelE, lAuiPC);

branching_unit bu (funct3E, Zero, ALUResult[31], TakeBranch);

// Pipeline Register 3 -> Execute | Memory

pl_ALU_DM pl_EM (clk, RegWriteE, ResultSrcE, MemWriteE, ALUResult, WriteDataE, RdE, PCPlus4E, funct3E, PCE, lAuiPC,
                RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, RdM, PCPlus4M, funct3M, PCM, lAuiPCM);

	
// Pipeline Register 4 -> Memory | Writeback

 pl_DM_Res pl_MW (clk, RegWriteM, ResultSrcM, ALUResultM, ReadData, RdM, PCPlus4M, PCM, WriteDataM, lAuiPCM,
                  RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RdW, PCPlus4W, PCW, WriteDataW, lAuiPCW);  
      
// Result Source
mux4 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W, lAuiPCW, ResultSrcW, Result);

// hazard unit

 hazard_unit hzrd (InstrD[19:15], InstrD[24:20], Rs1E, Rs2E, RdE, RdM, RdW, ResultSrcE, PCSrc, RegWriteM, RegWriteW, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);


assign Mem_WrData = WriteDataM;
assign Mem_WrAddr = ALUResultM;

endmodule
