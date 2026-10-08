/*
    CS 147 Spring 26
    Homework #1, problem 1

    4-bit 4:1 multiplexer.
*/
module mux4_1_4b(out, inA, inB, inC, inD, s);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 4;

    output [N-1:0]  out;
    input [N-1:0]   inA, inB, inC, inD;
    input [1:0]     s;

    // YOUR CODE HERE
	//Bit 0
	mux4_1 mux4_1_A(.inA(inA[0]), .inB(inB[0]), .inC(inC[0]), .inD(inD[0]), .s(s), .out(out[0])); 
	//Bit 1
	mux4_1 mux4_1_B(.inA(inA[1]), .inB(inB[1]), .inC(inC[1]), .inD(inD[1]), .s(s), .out(out[1])); 
	//Bit 2
	mux4_1 mux4_1_C(.inA(inA[2]), .inB(inB[2]), .inC(inC[2]), .inD(inD[2]), .s(s), .out(out[2])); 
	//Bit 3
	mux4_1 mux4_1_D(.inA(inA[3]), .inB(inB[3]), .inC(inC[3]), .inD(inD[3]), .s(s), .out(out[3])); 


endmodule
