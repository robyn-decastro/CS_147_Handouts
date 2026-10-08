/*
    CS 147 Spring 26
    Homework #3, problem 2

    Bypass wrapper around the register file.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
	
	
	wire [15:0] readTemp1; 
	wire [15:0] readTemp2; 
	regFile regFile(.read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), 
		.writeEn(writeEn), .read1Data(readTemp1), .read2Data(readTemp2), .clk(clk), .rst(rst), .err(err)); 

	wire [15:0] readTemp1_b;
	wire [15:0] readTemp2_b; 
	assign readTemp1_b = read1RegSel == writeRegSel ? writeData : readTemp1; 
	assign readTemp2_b = read2RegSel == writeRegSel ? writeData : readTemp2; 

	assign read1Data = writeEn == 1 ? readTemp1_b : readTemp1;
	assign read2Data = writeEn == 1 ? readTemp2_b : readTemp2; 



endmodule
