`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 12:13:07 AM
// Design Name: 
// Module Name: controller_TB
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


module controller_TB();
            reg [31:0] instr;
           reg zero;
           wire [2:0] alucontrol;
           wire regwrite,memwrite;
           wire pcsrc, alusrc;
           wire [1:0] immsrc , resultsrc;

controller uut (instr ,zero,alucontrol,regwrite,memwrite, pcsrc, alusrc,
                    immsrc , resultsrc);
 initial begin
          zero= 0 ;instr = 32'hFF718393; #20;
          zero=1; instr = 32'h0023E233; #20;
 end                   
endmodule
