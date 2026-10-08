/*
    CS 147 Spring 26
    Homework #1, problem 2

    1-bit full adder.
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
    input   a, b;
    input  c_in;

    // YOUR CODE HERE

	//A XOR B to x1
	wire x1; 
	xor2 xor2_AB (.in1(a), .in2(b), .out(x1)); 
	
	//x1 XOR Cin to Sum
	xor2 xor2_xC (.in1(x1), .in2(c_in), .out(s)); 
	
	//NOT(A NAND B) to y2
	wire x2, y2; 
	nand2 nand2_AB (.in1(a), .in2(b), .out(x2)); 
	not1 not1_x2 (.in1(x2), .out(y2)); 

	//NOT(Cin NAND x1) to y3
	wire x3, y3; 
	nand2 nand2_x1Cin (.in1(c_in), .in2(x1), .out(x3)); 
	not1 not1_x3 (.in1(x3), .out(y3)); 

	//NOT (y3 NOR y2) 
	wire x4; 
	nor2 nor2_y3y4 (.in1(y3), .in2(y2), .out(x4)); 
	not1 not1_x4 (.in1(x4), .out(c_out)); 


endmodule
