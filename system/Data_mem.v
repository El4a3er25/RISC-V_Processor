`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 12:30:49 AM
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
              input clk , we,
              input [31:0] a ,wd,
              output [31:0] rd
    );
     reg [31:0] RAM [0:255] ;
       
       always @(posedge clk)
       if(we) RAM[a] <= wd;
       
       assign rd = RAM[a];
             
endmodule
