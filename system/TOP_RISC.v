`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 12:54:47 AM
// Design Name: 
// Module Name: TOP_RISC
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


module TOP_RISC(
          input clk , reset,
          output [31:0] pc,
          output [31:0] aluresult , writedata
    );
    wire [31:0] instr , readdata;
    wire [2:0] alucontrol;
    wire memwrite, regwrite ,pcsrc, alusrc , zero;
    wire [1:0] immsrc , resultsrc;
    
    
    instr_mem uut0 (.a_instr(pc),
                    .rd_instr(instr));
                    
    Data_mem uut1 (.clk(clk),
                   .we(memwrite),
                   .a(aluresult),
                   .wd(writedata),
                   .rd(readdata));    
     
     Data_path uut2 (.clk(clk),
                     .reset(reset),
                     .alucontrol(alucontrol),
                     .regwrite(regwrite),
                     .pcsrc(pcsrc),
                     .alusrc(alusrc),
                     .immsrc(immsrc),
                     .resultsrc(resultsrc),
                     .instr(instr),
                     .readdata(readdata),
                     .zero(zero),
                     .writedata(writedata),
                     .pc(pc),
                     .aluresult(aluresult)
     ); 
     
    controller uut3 (.instr(instr),
                     .zero(zero),
                     .alucontrol(alucontrol),
                     .regwrite(regwrite),
                     .memwrite(memwrite),
                     .pcsrc(pcsrc),
                     .alusrc(alusrc),
                     .immsrc(immsrc),
                     .resultsrc(resultsrc)
                     );                          
endmodule
