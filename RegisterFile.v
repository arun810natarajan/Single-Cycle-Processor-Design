`timescale 1ns / 1ps 

module RegisterFile(
    input [4:0] RA, RB, RW,        
    input [63:0] BusW,             
    input RegWr,                   
    input Clk,                     

    output [63:0] BusA,            
    output [63:0] BusB             
);

    // Memory array to store register values, 64-bit wide and 32 entries
    reg [63:0] registers [31:0];

    // Initialize the stack pointer or a specific register at simulation start
    initial begin 
        registers[31] = 64'b0; // Often register 31 is used as a stack pointer, initialized to 0
    end

    // Assign output buses with a delay of 2 simulation time units
    // Reading the values stored in the registers indexed by RA and RB
    assign #2 BusA = registers[RA];
    assign #2 BusB = registers[RB];
    
    // Procedural block triggered on the negative edge of the clock
    always @(negedge Clk) begin
        // Check if the write enable is active and the target register is not register 31
        if (RegWr && RW != 31) begin
            // Write the value on BusW into the register indexed by RW with a delay of 3 time units
            registers[RW] <= #3 BusW;
        end
    end

endmodule
