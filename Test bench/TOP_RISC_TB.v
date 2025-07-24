`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 12:47:25 AM
// Design Name: 
// Module Name: TOP_RISC_TB
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


module TOP_RISC_TB();
          reg clk , reset;
          wire [31:0] pc;
          wire [31:0] aluresult , writedata;
          
      TOP_RISC uut (clk , reset , pc ,aluresult , writedata);    
      
      always #5 clk=~clk;
      
      initial begin
          clk=0;
          reset=0;
         #5;
          reset=1;
      end
endmodule
