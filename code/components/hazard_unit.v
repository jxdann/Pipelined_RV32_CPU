module hazard_unit(
    input [4:0] Rs1D, Rs2D,
    input [4:0] Rs1E, Rs2E,
    input [4:0] RdE, RdM, RdW,
    input [1:0] ResultSrcE,
    input PCSrc,
    input RegWriteM, RegWriteW,
    output reg StallF,
    output reg StallD, FlushD,
    output reg FlushE,
    output reg [1:0] ForwardAE, ForwardBE
);

reg lwStall;

always @(*) begin
    if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) begin
        ForwardAE = 2'b10;
    end else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0)) begin
        ForwardAE = 2'b01;
    end else begin
        ForwardAE = 2'b00;
    end

    if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) begin
        ForwardBE = 2'b10;
    end else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0)) begin
        ForwardBE = 2'b01;
    end else begin
        ForwardBE = 2'b00;
    end

    lwStall = ResultSrcE && ((Rs1D == RdE) || (Rs2D == RdE));
    StallF  = lwStall;
    StallD  = lwStall;

    FlushD = PCSrc;
    FlushE = lwStall || PCSrc;

end
endmodule