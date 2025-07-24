`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 09:34:59 PM
// Design Name: 
// Module Name: risc_v
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


module risc_v( // i/o data memory
          input clk ,reset , we,
          input [31:0] a ,wd, 
          output [31:0] rd, 
          // i/o instraction memory
          input [31:0] a_instr , 
          output [31:0] rd_instr,
          ///////////////////////controler////////////////////
          // i/o Main Decoder 
          input [6:0] op,
          output memwrite , regwrite,
          output pcsrc, alusrc,
          output [1:0] immsrc , resultsrc,
         /////ALU decoder
         input [2:0] funct3,
         input funct7,
         output reg [2:0] alucontrol, 
         /////////////////////////////////DATA PATH//////////////////////////////////// 
         ///////immediate entender////////////
         output reg [31:0] extimm,
         ////////register file///////////
         input [4:0] a1, a2, wa3,
         input wd3 , we3,
         output [31:0] rd1 , rd2   
    );
    
    //////////////Data memory///////////////
    reg [31:0] RAM [0:63] ;
    
    always @(posedge clk)
    if(we) RAM[a] <= wd;
    
    assign rd = RAM[a],
           wd = rd2,
           we = memwrite;
   //////////// instraction memory/////////////
   reg [31:0] rom [0:63];
   initial 
     $readmemh("memfile.mem", rom);
     
     assign rd_instr = rom[a_instr];
 ///////   ///////////////////////controler///////////////////////// 
   /////////  MainDecoder//////////////
   wire [1:0]  aluop;
   reg [10:0] controls;
   wire branch , jump ,zero ;
   assign pcsrc = zero & branch | jump,
     {regwrite ,immsrc ,alusrc, memwrite ,resultsrc ,branch , aluop,jump } = controls ; 
   
 always @(*)
 begin
          casez(op)
                7'b0000011 : controls = 11'b1_00_1_0_01_0_00_0; //lw
                7'b0100011 : controls = 11'b0_01_1_1_xx_0_00_0; //sw
                7'b0110011 : controls = 11'b1_xx_0_0_00_0_10_0; // R-type instraction
                7'b1100011 : controls = 11'b0_10_0_0_xx_1_01_0; // beg 
                7'b0010011 : controls = 11'b1_00_1_0_00_0_10_0; //I-type
                7'b1101111 : controls = 11'b1_11_x_0_10_0_xx_1; // jal
          endcase
 end    
 assign op = rd_instr[6:0],
        funct3 = rd_instr[14:12],
        funct7 = rd_instr[30];
 ///////////ALU decoder //////////////
 wire addsubtype ;
  assign addsubtype = funct7 & op[5]; 
 always @(*)
 begin
          case(aluop)
              2'b00 : alucontrol = 3'b000; //add
              2'b01 : alucontrol = 3'b001; //sub
              default : casex({funct3 , addsubtype})
                         4'b0000 : alucontrol = 3'b000; //add
                         4'b0001 : alucontrol = 3'b001; //sub
                         4'b0100 : alucontrol = 3'b101; // slt
                         4'b1100 : alucontrol = 3'b011; // or
                         4'b1110 : alucontrol =3'b010; //and
                         default : alucontrol = 3'bxxx; //non
                        endcase
          endcase
 end 
 /////////////////////////////////DATA PATH /////////////////////////////
 ////immediate entender
 always @(*)
 begin
              casex(immsrc)
                   2'b00: extimm = {{20{rd_instr[31]}}, rd_instr[31:20]}; //12-bit signed(I-type) 
                   2'b01: extimm = {{20{rd_instr[31]}}, rd_instr[31:25], rd_instr[11:7]}; //12-bit signed(s-type)
                   2'b10: extimm = {{20{rd_instr[31]}}, rd_instr[7], rd_instr[30:25], rd_instr[11:8], 1'b0}; //13-bit signed(B-type)
                   2'b11: extimm = {{12{rd_instr[31]}}, rd_instr[19:12], rd_instr[20], rd_instr[30:21], 1'b0}; //21-bit signed(J-type)
                   default: extimm = 32'bx;    
              endcase
 end
 ////////////register file////////
 reg [31:0] rf [31:0];
 always @(posedge clk )
      if(we3) rf[wa3] <= wd3 ;   
 
 assign rd1 = (a1 != 0)? rf[a1] : 0,
        rd2 = (a2 != 0)? rf[a2] : 0;
        
 assign a1 = rd_instr[19:15],
        a2 = rd_instr[24:20],
        wa3 = rd_instr[11:7],
        we3 = regwrite;
 /////////////////////ALU////////////////////
 reg [31:0] aluresult;
 wire  srcb;
  always @(*)
  begin
          case(alucontrol)
              3'b000: aluresult = rd1+srcb;
              3'b001: aluresult = rd1-srcb;
              3'b011: aluresult = rd1| srcb;
              3'b010: aluresult = rd1& srcb;
              3'b101: aluresult = (rd1<srcb)? 1:0;
          endcase
  end  
  assign zero = (~aluresult)? 1:0;
  assign a = aluresult;
   ///////////////////PC/////////////
   reg [31:0] pc   ; 
   wire [31:0] pcplus4 , pctarget, pcnext;
   always @(posedge clk , negedge reset)
   begin
       if(!reset) 
       pc <=0;
       else 
       pc <= pcnext;   
       end 
       assign a_instr = pc, 
              pcplus4 = pc +4,
              pctarget = pc + extimm;
               
    ////////////////MUX/////////////////
    wire [31:0] result;
  assign pcnext = (pcsrc)? pctarget : pcplus4,
         srcb = (alusrc)? extimm : rd2,
         result = (resultsrc[1])? pcplus4 : (resultsrc[0]? rd : aluresult); 
  assign wd3 = result;     
endmodule
