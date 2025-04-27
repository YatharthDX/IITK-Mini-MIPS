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

module main_tb;
  reg clk = 0, reset = 0;
  main uut(.clk(clk), .reset(reset));
  
  always #2 clk <= ~clk; // 10ns clock period

  initial begin
          $monitor("At time %0t, Register x: %b, Register y: %b, Register opcode: %b", $time, uut.registers[0], uut.PC, uut.opcode);

      reset = 1;
      #10 reset = 0;
      
      #10000 $finish;
  end
endmodule
