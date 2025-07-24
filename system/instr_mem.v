`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module instr_mem(input [31:0] a_instr , 
                 output [31:0] rd_instr
);
       reg [31:0] rom [0:127];
    initial 
      $readmemh("memfile.mem", rom);
      
     
      assign rd_instr = rom[a_instr>>2];
endmodule
