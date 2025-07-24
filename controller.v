`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module controller(
       input      [31:0] instr,
       input             zero,
       output reg [2:0]  alucontrol,
       output            regwrite,memwrite,
       output            pcsrc, alusrc,
       output     [1:0]  immsrc , resultsrc
            
    );
       /////////  MainDecoder//////////////
    wire [1:0] aluop;
    wire [6:0] op;
    wire [2:0] funct3;
    wire       funct7; 
    reg [10:0] controls;
    wire       branch , jump ;
    assign pcsrc = (zero & branch) | jump,
           {regwrite ,immsrc ,alusrc, memwrite ,resultsrc ,branch , aluop,jump } = controls ; 
    
  always @(*)
  begin
           casex(op) 
                 7'b0000011 : controls = 11'b1_00_1_0_01_0_00_0; //lw
                 7'b0100011 : controls = 11'b0_01_1_1_xx_0_00_0; //sw
                 7'b0110011 : controls = 11'b1_xx_0_0_00_0_10_0; // R-type instraction
                 7'b1100011 : controls = 11'b0_10_0_0_xx_1_01_0; // beq 
                 7'b0010011 : controls = 11'b1_00_1_0_00_0_10_0; //I-type
                 7'b1101111 : controls = 11'b1_11_x_0_10_0_xx_1; // jal
           endcase
  end    
  assign op = instr[6:0],
         funct3 = instr[14:12],
         funct7 = instr[30];
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
          4'b010X : alucontrol = 3'b101; // slt
          4'b110X : alucontrol = 3'b011; // or
          4'b111X : alucontrol = 3'b010; //and
          default : alucontrol = 3'b000; //non
               endcase
      endcase
  end
endmodule
