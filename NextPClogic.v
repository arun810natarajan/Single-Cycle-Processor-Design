module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
    input [63:0] CurrentPC, SignExtImm64;
    input Branch, ALUZero, Uncondbranch;
  output reg [63:0] NextPC; //changed to reg idk there was error

    //any changes in signal do stuff
    always @(*) begin
        if (Uncondbranch)
            // if unconditional branch is asserted, add the sign-extended immediate to the PC
            NextPC = CurrentPC + SignExtImm64;
        else if (Branch && ALUZero)
            // if a conditional branch & ALU condition is met
            NextPC = CurrentPC + SignExtImm64;
      
        else
            // by default add 4
            NextPC = CurrentPC + 4;
  
    end
  
endmodule