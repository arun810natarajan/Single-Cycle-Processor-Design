module SignExtender(
    output reg signed [63:0] BusImm,  
    input [25:0] Imm,                
    input [2:0] Ctrl                  
);

   
    always @(*) begin
        case (Ctrl) // Decision making based on the Ctrl input
            3'b000: 
                // Zero extend from bit 10 to bit 21
                BusImm = {{52{1'b0}}, Imm[21:10]};
            3'b001: 
                // Sign extend from bit 12 to bit 20, use bit 20 as the sign
                BusImm = {{55{Imm[20]}}, Imm[20:12]};
            3'b010: 
                // Sign extend the whole immediate, and shift left by 2 (multiply by 4)
                BusImm = {{36{Imm[25]}}, Imm[25:0], 2'b0};
            3'b011: 
                // Sign extend from bit 5 to bit 24, and shift left by 2
                BusImm = {{43{Imm[24]}}, Imm[23:5], 2'b0};

            // MovZ (Move Zero) instructions with different shifts
            3'b100: 
                // Zero extend and shift left by 0 bits
                BusImm = {{48{1'b0}}, Imm[20:5]};
            3'b101: 
                // Zero extend and shift left by 16 bits
                BusImm = {{32{1'b0}}, Imm[20:5], 16'b0};
            3'b110: 
                // Zero extend and shift left by 32 bits
                BusImm = {{16{1'b0}}, Imm[20:5], 32'b0};
            3'b111: 
                // Zero extend and shift left by 48 bits
                BusImm = {Imm[23:5], 48'b0};

            // Default case to handle undefined control codes
            default: 
                BusImm = 64'b0;  // Set output to zero if control code is undefined
        endcase
    end
endmodule // End of SignExtender module


     
