/*
    CS 147 Spring 26
    Homework #1, problem 2

    16-bit carry-lookahead adder.
*/
module cla_16b(sum, c_out, a, b, c_in, sign);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;
	input sign; 
	
	wire [3:0] p,g; 
	

    // First group, use p and g from it
	wire x1, x2, x3, x4, c1; 
	cla_4b cla_4b_0 (.a(a[3:0]), .b(b[3:0]), .c_in(c_in), .c_out(x1), .sum(sum[3:0]), .p(p[0]), .g(g[0])); 
	
	nand2 nand2_0 (.in1(p[0]), .in2(c_in), .out(x2));
	not1 not1_0 (.in1(x2), .out(x3)); 
	nor2 nor2_0 (.in1(g[0]), .in2(x3), .out(x4)); 
	not1 not1_01 (.in1(x4), .out(c1)); 


	wire y1, y2, y3, y4, c2; 
	cla_4b cla_4b_1 (.a(a[7:4]), .b(b[7:4]), .c_in(c1), .c_out(y1), .sum(sum[7:4]), .p(p[1]), .g(g[1])); 
	
	nand2 nand2_1 (.in1(p[1]), .in2(c1), .out(y2));
	not1 not1_1 (.in1(y2), .out(y3)); 
	nor2 nor2_1 (.in1(g[1]), .in2(y3), .out(y4)); 
	not1 not1_11 (.in1(y4), .out(c2)); 
	
	wire z1, z2, z3, z4, c3; 
	cla_4b cla_4b_2 (.a(a[11:8]), .b(b[11:8]), .c_in(c2), .c_out(z1), .sum(sum[11:8]), .p(p[2]), .g(g[2])); 
	
	nand2 nand2_2 (.in1(p[2]), .in2(c2), .out(z2));
	not1 not1_2 (.in1(z2), .out(z3)); 
	nor2 nor2_2 (.in1(g[2]), .in2(z3), .out(z4)); 
	not1 not1_21 (.in1(z4), .out(c3)); 	

	wire w1, w2, w3, w4, c4; 
	cla_4b cla_4b_3 (.a(a[15:12]), .b(b[15:12]), .c_in(c3), .c_out(w1), .sum(sum[15:12]), .p(p[3]), .g(g[3])); 
	
	nand2 nand2_3 (.in1(p[3]), .in2(c3), .out(w2));
	not1 not1_3 (.in1(w2), .out(w3)); 
	nor2 nor2_3 (.in1(g[3]), .in2(w3), .out(w4)); 
	not1 not1_31 (.in1(w4), .out(c_out)); 	
	


	



	
	
endmodule
