`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////
module Data_path(input clk , reset,
                 input [2:0] alucontrol,
                 input regwrite,
                 input pcsrc, alusrc,
                 input [1:0] immsrc , resultsrc,
                 input [31:0] instr,readdata,
                 output zero , 
                 output [31:0] writedata,
                 output reg [31:0] pc = 0 ,
                 output reg [31:0] aluresult 
    );
    reg [31:0] immext;
     ////immediate entender 
    always @(*)
    begin
         casex(immsrc)
           2'b00: immext = {{20{instr[31]}}, instr[31:20]}; //12-bit signed(I-type)  
            2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; //12-bit signed(s-type)
            2'b10: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; //13-bit signed(B-type)
            2'b11: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //21-bit signed(J-type)
            //default: immext = 32'bx;    
          endcase
    end
     ////////////register file////////
    wire [4:0] a1, a2, wa3;
    wire [31:0] wd3 ;
    wire [31:0] rd1; 
    reg [31:0] ram [31:0];
    always @(posedge clk )
         if(regwrite) ram[wa3] <= wd3 ;   
    
    assign rd1 = (a1 != 0)? ram[a1] : 0,
           writedata = (a2 != 0)? ram[a2] : 0;
           
    assign a1 = instr[19:15], 
           a2 = instr[24:20],
           wa3 = instr[11:7];
         
     /////////////////////ALU////////////////////
           wire [31:0] srcb;
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
           // assign zero = (~aluresult)? 1:0;
            assign zero = aluresult == 32'd0;
             ///////////////////PC/////////////
             wire [31:0] pcplus4 , pctarget;
             wire [31:0] pcnext;
             always @(posedge clk , negedge reset)
             begin                
                 if(!reset) 
                 pc <=0;
                 else  
                 pc <= pcnext;                    
                 end    
                     
                 assign pcplus4 = pc +4,
                        pctarget = pc + immext; 
                         
              ////////////////MUX/////////////////
        wire [31:0] result;   
        assign pcnext = (pcsrc)? pctarget : pcplus4,
           srcb = (alusrc)? immext : writedata,
           result = (resultsrc[1])? pcplus4 : (resultsrc[0]? readdata : aluresult); 
            assign wd3 = result;       
endmodule
