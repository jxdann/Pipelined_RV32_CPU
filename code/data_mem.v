
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input [2:0] funct3,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output reg  [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            data_ram[i] = 32'b0;  // Initialize each location to zero
        end
    end

wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64;

    reg [7:0] byte_data;  
    reg [15:0] half_data;
// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin 
        case(funct3)
            3'b000: begin // sb - store byte
                data_ram[word_addr] <= (data_ram[word_addr] & ~(8'hFF << (wr_addr[1:0] * 8))) | (wr_data[7:0] << (wr_addr[1:0] * 8));
            end
            3'b001: begin // sh - store halfword
                data_ram[word_addr] <= (data_ram[word_addr] & ~(16'hFFFF << (wr_addr[1] * 16))) | (wr_data[15:0] << (wr_addr[1] * 16));
            end
            3'b010: data_ram[word_addr] <= wr_data; // sw - store word
        endcase
    end
end

always @(*) begin
    // Select the appropriate byte based on address alignment
    case(wr_addr[1:0])
        2'b00: byte_data = data_ram[word_addr][7:0];     // Read lower byte
        2'b01: byte_data = data_ram[word_addr][15:8];    // Read second byte
        2'b10: byte_data = data_ram[word_addr][23:16];   // Read third byte
        2'b11: byte_data = data_ram[word_addr][31:24];   // Read upper byte
    endcase

    // Select the appropriate halfword based on address alignment
    case(wr_addr[1])
        1'b0: half_data = data_ram[word_addr][15:0];  // lower halfword
        1'b1: half_data = data_ram[word_addr][31:16]; // upper halfword
    endcase

    // Handle the read operation based on funct3 (sign or zero-extended)
    case(funct3)
        3'b000: rd_data_mem = {{24{byte_data[7]}}, byte_data};     // lb - sign-extended byte
        3'b001: rd_data_mem = {{16{half_data[15]}}, half_data};    // lh - sign-extended halfword
        3'b100: rd_data_mem = {24'b0, byte_data};                  // lbu - zero-extended byte
        3'b101: rd_data_mem = {16'b0, half_data};                  // lhu - zero-extended halfword
        3'b010: rd_data_mem = data_ram[word_addr];                 // lw - load word
        default: rd_data_mem = 32'b0;                              // Default case: no data
    endcase
end

endmodule

