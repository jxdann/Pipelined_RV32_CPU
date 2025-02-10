
// alu_decoder.v - logic for ALU decoder

module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [1:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // ADD operation (e.g., for load/store)
        2'b01: ALUControl = 4'b0001;             // SUB operation (e.g., for branch)
        default: begin
            case (funct3) // R-type or I-type ALU instructions
                3'b000: begin
                    // Handle R-type ADD and SUB based on funct7b5 and opb5
                    ALUControl = (funct7b5 & opb5) ? 4'b0001 : 4'b0000; // SUB / ADD
                end
                3'b001: ALUControl = 4'b0111;    // SLL (Shift Left Logical)
                3'b010: ALUControl = 4'b1000;    // SLT (Set Less Than - Signed)
                3'b011: ALUControl = 4'b0110;    // SLTU (Set Less Than Unsigned)
                3'b100: ALUControl = 4'b0100;    // XOR (XOR/XORI)
                3'b101: begin
                    // SRA or SRL determined by funct7b5
                    ALUControl = 4'b0101 ; // SRA / SRL (Shift Right Arithmetic/Logical)
                end
                3'b110: ALUControl = 4'b0011;    // OR (OR/ORI)
                3'b111: ALUControl = 4'b0010;    // AND (AND/ANDI)
                default: ALUControl = 4'bxxxx;   // Undefined operation
            endcase
        end
    endcase
end

endmodule

