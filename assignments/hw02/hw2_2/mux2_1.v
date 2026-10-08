/*
    CS 147 Spring 26
    Homework #1, problem 1

    1-bit 2:1 multiplexer.
*/
module mux2_1(out, inA, inB, s);
    output  out;
    input   inA, inB;
    input   s;
   
	wire x, y, z; 
	//A AND !S
	not1 not1_0 ( .in1(s), .out(x)); 
	nand2 nand2_0 ( .in1(inA), .in2(x), .out(y)); 
	not1 not1_1 ( .in1(y), .out(z)); 

	//B AND S 
	wire x1, y1;
	nand2 nand2_1 (.in1(inB), .in2(s), .out(y1)); 
	not1 not1_2 (.in1(y1), .out(x1)); 

	//Final output
	wire x2; 
	nor2 nor2_0 (.in1(x1), .in2(z), .out(x2)); 
	not1 not1_3 (.in1(x2), .out(out)); 



	
		
    // YOUR CODE HERE
    
endmodule
