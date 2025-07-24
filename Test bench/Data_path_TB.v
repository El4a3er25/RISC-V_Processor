`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 09:37:41 PM
// Design Name: 
// Module Name: Data_path_TB
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


module Data_path_TB();
                 reg clk , reset;
                 reg [2:0] alucontrol;
                 reg regwrite;
                 reg pcsrc, alusrc;
                 reg [1:0] immsrc , resultsrc;
                 reg [31:0] instr,readdata;
                 wire zero;
                 wire [31:0] writedata;
                 wire [31:0] pc ,aluresult;
  Data_path uut (clk , reset ,alucontrol ,regwrite,pcsrc, alusrc,
            immsrc , resultsrc, instr,readdata,zero , writedata,pc ,aluresult);
            
 always #5 clk =~clk;
                     
   initial begin
          clk =0;
          reset =0;
          #20;
         
          reset=1;
        instr =32'hFF718393;
        
        alucontrol = 3'b000;
        regwrite = 1; 
        {pcsrc, alusrc,immsrc , resultsrc,instr,readdata}= 6'b010000;
   end                       
endmodule
