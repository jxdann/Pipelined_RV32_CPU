module pl_RfE_ALU (
    input clk, clr, 
    input  [1:0] ResultSrcD,
    input        MemWriteD,
    input        ALUSrcD,
    input        RegWriteD, BranchD, JumpD, JalrD,
    input  [1:0] ImmSrcD,
    input  [3:0] ALUControlD,
    input  [31:0] RD1D, RD2D, PCD, PCPLus4D, ImmExtD, 
    input  [4:0] Rs1D, Rs2D, RdD,
    input        funct7b5D,
	 input  [2:0] funct3D, 
    input [19:0] auiImmD,
    input        lauiSelD,
    output reg [1:0] ResultSrcE,
    output reg      MemWriteE,
    output reg      ALUSrcE,
    output reg      RegWriteE, BranchE, JumpE, JalrE,
    output reg [1:0] ImmSrcE,
    output reg [3:0] ALUControlE,
    output reg funct7b5E,
	 output reg [2:0] funct3E, 
    output reg [31:0] RD1E, RD2E, PCE, PCPLus4E, ImmExtE,
    output reg [4:0] Rs1E, Rs2E, RdE,
    output reg [19:0] auiImmE,
    output reg        lauiSelE
);

initial begin
    ResultSrcE = 0;
    MemWriteE = 0;
    ALUSrcE = 0;
    RegWriteE = 0;
    BranchE = 0; 
    JumpE = 0;
    JalrE = 0;
    ImmSrcE = 0;
    ALUControlE = 0;
    funct7b5E = 0;
	 funct3E = 0;
    RD1E = 0; 
    RD2E = 0; 
    PCE = 0;
    PCPLus4E = 0; 
    ImmExtE = 0;
    Rs1E = 0; 
    Rs2E = 0;
    RdE = 0;
    auiImmE = 0;
    lauiSelE = 0;
end

always @(posedge clk) begin
    if (clr) begin
        ResultSrcE <= 0;
        MemWriteE <= 0;
        ALUSrcE <= 0;
        RegWriteE <= 0;
        BranchE <= 0; 
        JumpE <= 0;
        JalrE <= 0;
        ImmSrcE <= 0;
        ALUControlE <= 0;
        funct7b5E <= 0;
		  funct3E <= 0;
        RD1E <= 0; 
        RD2E <= 0; 
        PCE <= 0;
        PCPLus4E <= 0; 
        ImmExtE <= 0;
        Rs1E <= 0;
        Rs2E <= 0; 
        RdE <= 0;
        auiImmE <= 0;
        lauiSelE <= 0;
    end else begin
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        ALUSrcE <= ALUSrcD;
        RegWriteE <= RegWriteD;
        BranchE <= BranchD; 
        JumpE <= JumpD;
        JalrE <= JalrD;
        ImmSrcE <= ImmSrcD;
        ALUControlE <= ALUControlD;
        funct7b5E <= funct7b5D;
		  funct3E <= funct3D;
        RD1E <= RD1D; 
        RD2E <= RD2D; 
        PCE <= PCD; 
        PCPLus4E <= PCPLus4D;
        ImmExtE <= ImmExtD;
        Rs1E <= Rs1D; 
        Rs2E <= Rs2D; 
        RdE <= RdD;
        auiImmE <= auiImmD;
        lauiSelE <= lauiSelD;
    end
end

endmodule
