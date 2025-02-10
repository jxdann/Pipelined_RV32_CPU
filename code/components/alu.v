
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    input       funct7b5,
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(*) begin
    case (alu_ctrl)
        4'b0000:  alu_out <= a + b;           // ADD / ADDI
        4'b0001:  alu_out <= a - b;           // SUB / SUBI
        4'b0010:  alu_out <= a & b;           // AND / ANDI
        4'b0011:  alu_out <= a | b;           // OR / ORI
        4'b0100:  alu_out <= a ^ b;           // XOR / XORI
        4'b0101: begin                        // Shift operations
            if (funct7b5) alu_out <= $signed(a) >>> b[4:0];   // SRA / SRAI (arithmetic shift)
            else alu_out <= a >> b[4:0];                      // SRL / SRLI (logical shift)
        end
        4'b0110:  alu_out <= a < b ? 1 : 0;   // SLTU (unsigned comparison)
        4'b0111:  alu_out <= a << b[4:0];     // SLL / SLLI (Shift Left Logical)
        4'b1000:  alu_out <= $signed(a) < $signed(b) ? 1 : 0;
        default: alu_out <= 0;               // Default case (no operation)
    endcase
end

// Zero flag: Indicates if the result of the ALU operation is zero
assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

