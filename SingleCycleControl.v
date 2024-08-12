`define OPCODE_ANDREG 11'b?0001010???
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000

// Control module declaration
module control(
    output reg    reg2loc,      
    output reg    alusrc,      
    output reg    mem2reg,      
    output reg    regwrite,     
    output reg    memread,      
    output reg    memwrite,     
    output reg    branch,       
    output reg    uncond_branch,
    output reg [3:0] aluop,     
    output reg [2:0] signop,    
    input [10:0]  opcode        
);

always @(*) begin
    casez (opcode) // Decoding the opcode
        // Logical AND between registers
        `OPCODE_ANDREG: begin
            reg2loc = 1'b0;
            alusrc = 1'b0;
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0000; // ALU operation code for AND
            signop = 3'bxxx; // Not applicable
        end
        // Logical OR between registers
        `OPCODE_ORRREG: begin
            reg2loc = 1'b0;
            alusrc = 1'b0;
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0001; // ALU operation code for OR
            signop = 3'bxxx; // Not applicable
        end
        // Addition between registers
        `OPCODE_ADDREG: begin
            reg2loc = 1'b0;
            alusrc = 1'b0;
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0010; // ALU operation code for ADD
            signop = 3'bxxx; // Not applicable
        end
        // Subtraction between registers
        `OPCODE_SUBREG: begin
            reg2loc = 1'b0;
            alusrc = 1'b0;
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0110; // ALU operation code for SUB
            signop = 3'bxxx; // Not applicable
        end
        // Addition with immediate
        `OPCODE_ADDIMM: begin
            reg2loc = 1'bx; // Irrelevant for immediate
            alusrc = 1'b1;  // Use immediate as ALU source
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0010; // ALU operation code for ADD
            signop = 3'b000; // Immediate processing option
        end
        // Subtraction with immediate
        `OPCODE_SUBIMM: begin
            reg2loc = 1'bx; // Irrelevant for immediate
            alusrc = 1'b1;  // Use immediate as ALU source
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0110; // ALU operation code for SUB
            signop = 3'b000; // Immediate processing option
        end
        // Move zero (constant) to register
        `OPCODE_MOVZ: begin
            reg2loc = 1'b1; // Use register location for move
            alusrc = 1'b1;  // Use immediate as ALU source
            mem2reg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0111; // ALU operation code for MOVZ
            signop = opcode[2:0]; // Use specific bits from opcode
        end
        // Unconditional branch
        `OPCODE_B: begin
            reg2loc = 1'bx; // Not applicable
            alusrc = 1'bx;  // Not applicable
            mem2reg = 1'bx; // Not applicable
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'bx;  // Not applicable
            uncond_branch = 1'b1; // Unconditional branch enabled
            aluop = 4'bxxxx; // Not applicable
            signop = 3'b010; // Branch processing option
        end
        // Conditional branch on zero
        `OPCODE_CBZ: begin
            reg2loc = 1'b1; // Use register for condition check
            alusrc = 1'b0;  // Use register value
            mem2reg = 1'bx; // Not applicable
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b1;  // Conditional branch enabled
            uncond_branch = 1'b0;
            aluop = 4'b0111; // ALU operation for condition check
            signop = 3'b011; // Branch processing option
        end
        // Load from memory
        `OPCODE_LDUR: begin
            reg2loc = 1'bx; // Not applicable
            alusrc = 1'b1;  // Use immediate for memory address
            mem2reg = 1'b1; // Load from memory to register
            regwrite = 1'b1;
            memread = 1'b1; // Memory read enabled
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0010; // ALU operation code for ADD (for address calculation)
            signop = 3'b001; // Memory address processing
        end
        // Store to memory
        `OPCODE_STUR: begin
            reg2loc = 1'b1; // Use register for address calculation
            alusrc = 1'b1;  // Use immediate for address offset
            mem2reg = 1'bx; // Not applicable
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b1; // Memory write enabled
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'b0010; // ALU operation code for ADD (for address calculation)
            signop = 3'b001; // Memory address processing
        end
        // Default case to handle unknown opcodes
        default: begin
            reg2loc = 1'bx;
            alusrc = 1'bx;
            mem2reg = 1'bx;
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            uncond_branch = 1'b0;
            aluop = 4'bxxxx;
            signop = 3'bxxx;
        end
    endcase
end

endmodule
