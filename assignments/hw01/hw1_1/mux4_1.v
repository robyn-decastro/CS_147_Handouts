/*
    CS 147 Spring 26
    Homework #1, problem 1

    1-bit 4:1 multiplexer built from 2:1 muxes.
*/
module mux4_1(out, inA, inB, inC, inD, s);
    output       out;
    input        inA, inB, inC, inD;
    input [1:0]  s;

    // YOUR CODE HERE
	wire x, y; 
	//Select A or B with s0
	mux2_1 mux2_1_AB ( .inA(inA), .inB(inB), .s(s[0]), .out(x));
	//Select C or D with s0 
	mux2_1 mux2_1_CD ( .inA(inC), .inB(inD), .s(s[0]), .out(y)); 
	//Select muxAB or muxCD from s1 
	mux2_1 mux2_1_all (.inA(x), .inB(y), .s(s[1]), .out(out)); 
	

endmodule
