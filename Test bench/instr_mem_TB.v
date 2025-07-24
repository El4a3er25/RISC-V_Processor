`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 03:49:54 PM
// Design Name: 
// Module Name: instr_mem_TB
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


module instr_mem_TB( );
          reg [31:0] a_instr ; 
          wire [31:0] rd_instr;
         
        instr_mem uut (a_instr, rd_instr); 
        
       initial begin
          
             a_instr =0 ;
             #10;
             a_instr =1 ;
              #10;
             a_instr =2 ;
              #10;
              a_instr =3 ;
              #10;
              a_instr =4 ;
              #10;
              a_instr =5 ;
              #10;
       end 
endmodule
