// Definition of the single-cycle CPU module
module singlecycle(
    input         resetl,           // Active low reset signal
    input [63:0]  startpc,          // Initial program counter address at startup
    output reg [63:0] currentpc,    // Current program counter value
    output [63:0] MemtoRegOut,      // Output from the MemtoReg Mux, goes to register file
    input wire [63:0] MemtoRegIn,   // Input to the MemtoReg Mux, comes from data memory
    input         CLK               // System clock signal
);

   // Connection for calculating the next PC
   wire [63:0] nextpc;

   // Connection for fetching instructions
   wire [31:0] instruction;

   // Breaking down the instruction into its components
   wire [4:0]  rd;          // Destination register identifier
   wire [4:0]  rm;          // Source register 1 identifier
   wire [4:0]  rn;          // Source register 2 or immediate identifier depending on instruction
   wire [10:0] opcode;      // Operation code to determine the instruction type

   // Control signals for orchestrating operations within the CPU
   wire        reg2loc;
   wire        alusrc;
   wire        mem2reg;
   wire        regwrite;
   wire        memread;
   wire        memwrite;
   wire        branch;
   wire        uncond_branch;
   wire [3:0]  aluctrl;
   wire [2:0]  signop;

   // Outputs from the register file
   wire [63:0] regoutA;     // Data from source register 1
   wire [63:0] regoutB;     // Data from source register 2 or for memory write

   // Output from the ALU
   wire [63:0] aluout;
   wire        zero;        // Flag indicating if the ALU output is zero

   // Output from ALU source multiplexer
   wire [63:0] aluMUXout;

   // Output from the sign extender
   wire [63:0] extimm;

   // Logic to update PC at the negative edge of the clock
   always @(negedge CLK) begin
       if (resetl)          // If not in reset
           currentpc <= #3 nextpc;  // Delay of 3 units for simulation accuracy
       else                 // If in reset
           currentpc <= #3 startpc; // Load initial PC after delay
   end

   // Decode parts of the instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   // Instruction memory module
   InstructionMemory imem(
       .Data(instruction),
       .Address(currentpc)
   );

   // Control unit module
   control control(
       .reg2loc(reg2loc),
       .alusrc(alusrc),
       .mem2reg(mem2reg),
       .regwrite(regwrite),
       .memread(memread),
       .memwrite(memwrite),
       .branch(branch),
       .uncond_branch(uncond_branch),
       .aluop(aluctrl),
       .signop(signop),
       .opcode(opcode)
   );

   // MUX for selecting ALU or memory data to write back to register file
   assign MemtoRegOut = mem2reg ? MemtoRegIn : aluout;

   // Sign extender for immediate values
   SignExtender SignExtender(
       .BusImm(extimm),
       .Imm(instruction[25:0]),
       .Ctrl(signop)
   );

   // Multiplexer for selecting ALU second operand
   assign aluMUXout = alusrc ? extimm : regoutB;

   // ALU module
   ALU ALU(
       .BusW(aluout),
       .BusA(regoutA),
       .BusB(aluMUXout),
       .ALUCtrl(aluctrl),
       .Zero(zero)
   );

   // Register file
   RegisterFile RegisterFile(
       .RA(rm),
       .RB(rn),
       .BusW(MemtoRegOut),
       .RW(rd),
       .RegWr(regwrite),
       .BusA(regoutA),
       .BusB(regoutB),
       .Clk(CLK)
   );

   // Logic to calculate next PC based on current PC, branches, and jumps
   NextPClogic NextPClogic(
       .NextPC(nextpc),
       .CurrentPC(currentpc),
       .SignExtImm64(extimm),
       .Branch(branch),
       .ALUZero(zero),
       .Uncondbranch(uncond_branch)
   );

   // Data memory for load/store instructions
   DataMemory DataMemory(
       .ReadData(MemtoRegIn),
       .Address(aluout),
       .WriteData(regoutB),
       .MemoryRead(memread),
       .MemoryWrite(memwrite),
       .Clock(CLK)
   );

endmodule
