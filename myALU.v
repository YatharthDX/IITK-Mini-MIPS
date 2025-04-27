`timescale 1ns / 1ps

module myALU (typee,rs,rt,rd,rd2,hi,lo,imm,shamt);

    input [6:0] typee;
    input [31:0] rs,rt;
    input [31:0] imm;
    input [4:0] shamt;
    input [31:0] hi,lo;
    output reg [31:0] rd,rd2; //will also work as hi

    always @(*) begin
        rd = 32'b0; 
        rd2 = 32'b0;
        case (typee)
            7'b0000000: rd = rs + rt; // ADD
            7'b0000001: rd = rs - rt; // SUB
            7'b0000010: rd = rs & rt; // AND
            7'b0000011: rd = rs | rt; // OR
            7'b0000100: rd = rs ^ rt; // XOR
            7'b0000101: rd = ~rs;     // NOT
            7'b0000110: rd = rs << shamt; // SLL
            7'b0000111: rd = rs >> shamt; // SRL
            7'b0001000: rd = rs >>> shamt; // SRA
            7'b0001001: rd = rs + imm; // ADDI
            7'b0001010: rd = rs - imm; // SUBI
            7'b0001011: rd = rs & imm; // ANDI
            7'b0001100: rd = rs | imm; // ORI
            7'b0001101: rd = rs ^ imm; // XORI
            7'b0001110: rd = rs + rt; // ADDU
            7'b0001111: rd = rs - rt; // SUBU
            7'b0010000: {rd,rd2} = rs*rt; // MADD
            7'b0010001: {rd,rd2} = rs*rt; // MADDU
            //mul will have first 32 bit in hi and second 32 bit in lo
            7'b0010010: begin // MUL
                {rd, rd2} = rs * rt; // Concatenate hi (rd) and lo
            end
            7'b0010011: begin // LW
                rd = rs + imm;
            end
            
            

            default: begin rd = 32'b0; rd2 = 32'b0;  end    // Default case
        endcase
    end

endmodule
