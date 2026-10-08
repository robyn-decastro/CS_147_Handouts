/*
    CS 147 Spring 26
    Homework #3, problem 1

    8x16 register file with 2 read ports and 1 write port.
*/
// Shared via symlink between assignments/hw03/hw3_1/regFile.v and assignments/hw03/hw3_2/regFile.v.
// WARNING: This file can be edited from either path, but DO NOT move or duplicate this file.
module regFile (
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
	
wire [7:0] totalErr;

   /* YOUR CODE HERE */
//
	
	
	parameter WIDTH = 16; 

	wire [WIDTH*8 - 1 : 0] readFullData; 
	
	wire [1:0] writeOnWire2; 
	assign writeOnWire2 = writeRegSel[0] == 1 ? 2'b10 : 2'b01; 
	wire [3:0] writeOnWire1; 
	assign writeOnWire1 = writeRegSel[1] == 1 ? {writeOnWire2, 2'b0} : {2'b0, writeOnWire2};  
	wire [7:0] writeOnWire;
	assign writeOnWire = (writeRegSel[2] == 1 ? {writeOnWire1, 4'b0} : {4'b0, writeOnWire1}) & {8{writeEn}}; 
	//Mux to enable write 

	register reg0(.q(readFullData[15 : 0]), .d(writeData), .en(writeOnWire[0]), .clk(clk), .rst(rst), .err(totalErr[0]));
	register reg1(.q(readFullData[31 : 16]), .d(writeData), .en(writeOnWire[1]), .clk(clk), .rst(rst), .err(totalErr[1]));
	register reg2(.q(readFullData[47 : 32]), .d(writeData), .en(writeOnWire[2]), .clk(clk), .rst(rst), .err(totalErr[2]));
	register reg3(.q(readFullData[63 : 48]), .d(writeData), .en(writeOnWire[3]), .clk(clk), .rst(rst), .err(totalErr[3]));
	register reg4(.q(readFullData[79 : 64]), .d(writeData), .en(writeOnWire[4]), .clk(clk), .rst(rst), .err(totalErr[4]));
	register reg5(.q(readFullData[95 : 80]), .d(writeData), .en(writeOnWire[5]), .clk(clk), .rst(rst), .err(totalErr[5]));
	register reg6(.q(readFullData[111 : 96]), .d(writeData), .en(writeOnWire[6]), .clk(clk), .rst(rst), .err(totalErr[6]));
	register reg7(.q(readFullData[127 : 112]), .d(writeData), .en(writeOnWire[7]), .clk(clk), .rst(rst), .err(totalErr[7]));

	assign read1Data = readFullData[read1RegSel * WIDTH +: WIDTH];	
	assign read2Data = readFullData[read2RegSel * WIDTH +: WIDTH]; 

	assign err = |totalErr === 1'bx;	

endmodule
