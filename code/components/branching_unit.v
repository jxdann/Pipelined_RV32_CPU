
// branching_unit.v - logic for branching in execute stage

module branching_unit (
    input [2:0] funct3,
    input       Zero, ALUR31,
    output reg  Branch
);

initial begin
    Branch = 1'b0;
end

always @(*) begin
    case (funct3)
        3'b000: Branch = Zero;        // beq (branch if equal)
        3'b001: Branch = !Zero;       // bne (branch if not equal)
        3'b100: Branch = ALUR31;      // blt (branch if less than, signed)
        3'b101: Branch = !ALUR31;     // bge (branch if greater or equal, signed)
        3'b110: Branch = !Zero;       // bltu (branch if less than, unsigned)
        3'b111: Branch = !ALUR31;     // bgeu (branch if greater or equal, unsigned)
    endcase
end

endmodule