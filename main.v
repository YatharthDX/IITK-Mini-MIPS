`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/26/2025 03:43:49 PM
// Design Name:
// Module Name: main
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module main(clk,reset);

    input clk,reset;
    
    reg [8:0] a_im = 0;
    reg we = 0;
    reg [31:0] d_im = 0;
    wire [31:0] dpo;
    wire [31:0] instruction;
    
    // Register file: 32 standard MIPS registers
    reg [31:0] registers [31:0];
    reg [31:0] float_registers [31:0];
    reg [8:0] PC;


//    reg [31:0] instruction_memory [0:127];
//    reg [31:0] data_memory [0:127];
    
    dist_mem_gen_2 instruction_memory (
      .a(a_im),        // input wire [8 : 0] a
      .d(d_im),        // input wire [31 : 0] d
      .dpra(PC),  // input wire [8 : 0] dpra
      .clk(clk),    // input wire clk
      .we(we),      // input wire we
      .dpo(instruction)    // output wire [31 : 0] dpo
    );
    
    reg [8:0] read_data;
    reg [31:0] data_input;
    wire [31:0] data_output;
    reg we_data = 0;
    reg [8:0] a_data;
    
    dist_mem_gen_1 data_memory (
      .a(a_data),        // input wire [8 : 0] a
      .d(data_input),        // input wire [31 : 0] d
      .dpra(read_data),  // input wire [8 : 0] dpra
      .clk(clk),    // input wire clk
      .we(we_data),      // input wire we
      .dpo(data_output)    // output wire [31 : 0] dpo
    );
    
    // Register names grouped by common usage:
    // Constant and reserved: $zero (0), $at (1), $hi-lo (26-27)
    // Function-related: $v0-v1 (2-3), $a0-a3 (4-7)
    // Temporary registers: $t0-t7 (8-15), $t8-t9 (24-25)
    // Saved registers: $s0-s7 (16-23)
    // Pointers: $gp (28), $sp (29), $fp (30), $ra (31)
    
    integer i;
    initial begin
        // Initialize all registers to 0
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
            float_registers[i] = 32'b0;
        end
        PC <= -1;
    end

    reg [6:0] alu_type;
    reg [31:0] imm;
    reg [4:0] shamt;

    // We have the instuction
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs_code = instruction[25:21];
    wire [4:0] rt_code = instruction[20:16];
    wire [4:0] rd_code = instruction[15:11];
    wire [4:0] shamt_code = instruction[10:6];
    wire [5:0] funct_code = instruction[5:0];
    wire [15:0] immediate = instruction[15:0];
    wire [25:0] target = instruction[25:0];

    wire [31:0] alu_result, alu_result_2;
    wire [31:0] rs, rt;
    wire [31:0] hi, lo;
    reg [31:0] fs,ft;
    wire [31:0] fd;
    

    assign rs = registers[rs_code];
    assign rt = registers[rt_code];
    
    assign hi = registers[26];
    assign lo = registers[27];
    

    myALU alu_inst(
        .typee(alu_type),
        .rs(rs),
        .rt(rt),
        .rd(alu_result),
        .rd2(alu_result_2),
        .hi(hi),
        .lo(lo),
        .imm(imm),
        .shamt(shamt)
    );
    
    
     floating_adder flu_inst(
         .inp1(fs),
         .inp2(ft),
         .out(fd)
     );

    always @(*) begin
    
        alu_type <= 7'b0000000;
        imm <= 0;
        shamt <= 0;

        case (opcode)
            6'b000000: begin // R-type
                case (funct_code)
                    6'b100000: alu_type <= 7'b0000000; // ADD
                    6'b100010: alu_type <= 7'b0000001; // SUB
                    6'b100001: alu_type <= 7'b0001110; // ADDU
                    6'b100011: alu_type <= 7'b0001111; // SUBU
                    6'b100100: alu_type <= 7'b0000010; // AND
                    6'b100101: alu_type <= 7'b0000011; // OR
                    6'b100110: alu_type <= 7'b0000100; // XOR
                    6'b100111: alu_type <= 7'b0000101; // NOT
                    6'b000000: begin alu_type <= 7'b0000110; shamt <= shamt_code; end // SLL
                    6'b000010: begin alu_type <= 7'b0000111; shamt <= shamt_code; end // SRL
                    6'b000011: begin alu_type <= 7'b0001000; shamt <= shamt_code; end // SRA
                    6'b011000: begin alu_type <= 7'b0010000; shamt <= shamt_code; end // MADD
                    6'b011001: begin alu_type <= 7'b0010001; shamt <= shamt_code; end // MADDU
                    default: alu_type <= 7'b1111111;
                endcase
            end
            6'b011100: begin // Special MUL opcode
                if (funct_code == 6'b000010)
                    alu_type <= 7'b0010010; // MUL
            end
            // I-type instructions
            6'b001000: begin alu_type <= 7'b0001001; imm <= {{16{immediate[15]}}, immediate}; end // ADDI
            6'b001001: begin alu_type <= 7'b0001010; imm <= {{16'b0}, immediate}; end // ADDIU
            6'b001100: begin alu_type <= 7'b0001011; imm <= {16'b0, immediate}; end // ANDI
            6'b001101: begin alu_type <= 7'b0001100; imm <= {16'b0, immediate}; end // ORI
            6'b001110: begin alu_type <= 7'b0001101; imm <= {16'b0, immediate}; end // XORI
            
            // lw, sw, beq, bne, etc.
            // These instructions will not use ALU directly but will be handled in the control unit
            6'b100011: begin alu_type <= 7'b0010011; imm <= {{16{immediate[15]}}, immediate}; read_data <= alu_result; end // LW
            6'b101011: begin alu_type <= 7'b0010011; imm <= {{16{immediate[15]}}, immediate}; end // SW
            6'b110110: begin 
//                 if(rs_code==5'b00000) begin registers[rt_code] <= float_registers[rd_code]; end //mfcl
//                 else if(rs_code==5'b00100) begin float_registers[rd_code] <= registers[rt_code]; end //mtc1
                 if(rs_code==5'b10000 && funct_code==6'b000000) begin
//                      fd <= registers[shamt_code];
                      fs <= float_registers[rd_code];
                      ft <= float_registers[rt_code];
                 end // add.s
                 else if(rs_code==5'b10000 && funct_code==6'b000001) begin
//                      assign fd <= registers[shamt_code];
                      
                      fs <= float_registers[rd_code];
                      ft <= 32'b10000000000000000000000000000000 ^ float_registers[rt_code]; // flips the sign of ft
                 end // sub.s
                 else begin end
            end
            // LUI doesnt required ALU
            // Add other instructions here
            default: alu_type <= 7'b1111111;
        endcase

         // Increment the program counter
         
    end
    

    // Register write-back logic
    always @(posedge clk) begin
       
        if (opcode == 6'b000000) begin // R-type
            registers[rd_code] <= alu_result;
            PC <= PC + 1;
        end else if (opcode == 6'b001000 || opcode == 6'b001001 || opcode == 6'b001100 ||  // I-type
                     opcode == 6'b001101 || opcode == 6'b001110) begin
            registers[rt_code] <= alu_result;
            PC <= PC + 1;
        end else if (opcode == 6'b011100) begin // MUL
            registers[26] <= alu_result;
            registers[27] <= alu_result_2;
            PC <= PC + 1;
        end else if (opcode == 6'b000000 && (funct_code==6'b011000 || funct_code==6'b011001)) begin // MADD or MADDU
            registers[26] <= alu_result;
            registers[27] <= alu_result_2;
            PC <= PC + 1;
        end else if (opcode == 6'b100011) begin // LW
            
            registers[rt_code] <= data_output;
            PC <= PC + 1;
        end else if (opcode == 6'b101011) begin // SW
            we_data = 1;
            data_input = registers[rt_code];
            a_data = alu_result;
//            data_memory[alu_result] <= registers[rt_code];
            PC <= PC + 1;
        end else if (opcode == 6'b001111) begin // LUI, not used ALU
            registers[rt_code][31:16] <= immediate ;
            PC <= PC + 1;
        end else if (opcode == 6'b000100) begin // BEQ
            if(registers[rs_code] == registers[rt_code]) begin
                PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC + 1; end
        end else if (opcode == 6'b000101) begin // BNE
            if(registers[rs_code] != registers[rt_code]) begin
                PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC + 1; end
        end else if (opcode == 6'b010000) begin // BGT
            if (registers[rs_code] > registers[rt_code]) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC + 1; end
        end else if (opcode == 6'b010001) begin // BGTE
            if (registers[rs_code] >= registers[rt_code]) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC+1; end
        end else if (opcode == 6'b010010) begin // BLE
            if (registers[rs_code] < registers[rt_code]) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC+1; end
        end else if (opcode == 6'b010011) begin // BLEQ
            if (registers[rs_code] <= registers[rt_code]) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC+1; end
        end else if (opcode == 6'b010100) begin // BLEU
            if ((registers[rs_code]) <= (registers[rt_code])) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC + 1; end
        end else if (opcode == 6'b010101) begin // BGTU
            if ((registers[rs_code]) > (registers[rt_code])) begin
            PC <= PC + {{16{immediate[15]}}, immediate};
            end
            else begin PC <= PC + 1; end
        end else if (opcode == 6'b000010) begin // J
            PC <= {{6{target[22]}},target};
        end else if (opcode == 6'b000011) begin // JAL
            registers[31] <= PC + 1; // Save return address in $ra
            PC <= {{6{target[22]}},target};
//        end else if (opcode == 6'b110110 && rs_code==5'b10000) begin
//              float_registers[shamt_code] = fd;
              
        end else if(opcode == 6'b110110)
        begin 
                 PC <= PC + 1;
                 if(rs_code==5'b00000) begin registers[rt_code] <= float_registers[rd_code]; end //mfcl
                 else if(rs_code==5'b00100) begin float_registers[rd_code] <= registers[rt_code]; end //mtc1
                 else if(rs_code==5'b10000) begin // add
                        float_registers[shamt_code] = fd;
//                      fd <= registers[shamt_code];
                 end // sub.s
                 else begin end
         end
        
        else begin
            PC <= PC + 1;
        end
         
        
        

    end



endmodule
