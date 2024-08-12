`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(
    output [63:0] BusW,     // Output bus for the result of the ALU operation
    input [63:0] BusA,      // Input bus A (first operand)
    input [63:0] BusB,      // Input bus B (second operand or pass-through when PassB operation)
    input [3:0] ALUCtrl,    // Control signal to determine the operation
    output Zero             // Flag that is set if the result of the operation is zero
);

   
    reg [63:0] BusW;

    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)  // Switch on ALU control code
            `AND: begin
                BusW = BusA & BusB;  // Perform bitwise AND on A and B
            end
            `OR: begin
                BusW = BusA | BusB;  // Perform bitwise OR on A and B
            end
            `ADD: begin
                BusW = BusA + BusB;  // Add A and B
            end
            `SUB: begin
                BusW = BusA - BusB;  // Subtract B from A
            end
            `PassB: begin
                BusW = BusB;         // Pass the value of B through to the output
            end
            default: begin
                BusW = 64'b0;        // Default case to handle undefined control codes
            end
        endcase
    end

    // Continuous assignment statement to update the Zero flag
    assign Zero = (BusW == 0);  // Set Zero to true if the result is zero

endmodule
