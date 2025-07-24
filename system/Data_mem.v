`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
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
