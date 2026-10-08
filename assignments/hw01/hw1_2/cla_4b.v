/*
    CS 147 Spring 26
    Homework #1, problem 2

    4-bit carry-lookahead adder.
*/
module cla_4b(sum, c_out, a, b, c_in, p, g);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

 	output p,g; 

    // YOUR CODE HERE

	//Calculate C0 
	
	fullAdder_1b fa_1 (.a(a[0]), .b(b[0]), .c_in(c_in), .s(sum[0]), .c_out()); 
	
	//c1 = G0 + (P0.C0)
	wire c1, g0, p0, x0, x01, x02, pc0; 
	nand2 nand2_0 (.in1(a[0]), .in2(b[0]), .out(x0)); 
	not1 not1_0 (.in1(x0), .out(g0)); 
	xor2 xor2_0 (.in1(a[0]), .in2(b[0]), .out(p0)); 
	nand2 nand2_01 (.in1(p0), .in2(c_in), .out(x01)); 
	not1 not1_01 (.in1(x01), .out(pc0)); 
	nor2 nor2_01 (.in1(g0), .in2(pc0), .out(x02)); 
	not1 not1_02 (.in1(x02), .out(c1)); 
	
	//c2 = G1 + (P1.C1)
	
	

	fullAdder_1b fa_2 (.a(a[1]), .b(b[1]), .c_in(c1), .s(sum[1]), .c_out()); 
	
	wire c2, g1, p1, x1, x11, x12, pc1; 
	nand2 nand2_1 (.in1(a[1]), .in2(b[1]), .out(x1)); 
	not1 not1_1 (.in1(x1), .out(g1)); 
	xor2 xor2_1 (.in1(a[1]), .in2(b[1]), .out(p1)); 
	nand2 nand2_11 (.in1(p1), .in2(c1), .out(x11)); 
	not1 not1_11 (.in1(x11), .out(pc1)); 
	nor2 nor2_11 (.in1(g1), .in2(pc1), .out(x12)); 
	not1 not1_12 (.in1(x12), .out(c2)); 

	//c3 = G2 + (P2.C2)
	fullAdder_1b fa_3 (.a(a[2]), .b(b[2]), .c_in(c2), .s(sum[2]), .c_out()); 
	
	wire c3, g2, p2, x2, x21, x22, pc2; 
	nand2 nand2_2 (.in1(a[2]), .in2(b[2]), .out(x2)); 
	not1 not1_2 (.in1(x2), .out(g2)); 
	xor2 xor2_2 (.in1(a[2]), .in2(b[2]), .out(p2)); 
	nand2 nand2_21 (.in1(p2), .in2(c2), .out(x21)); 
	not1 not1_21 (.in1(x21), .out(pc2)); 
	nor2 nor2_21 (.in1(g2), .in2(pc2), .out(x22)); 
	not1 not1_22 (.in1(x22), .out(c3)); 

	//c4 = G3 + (P3.C3)
	fullAdder_1b fa_4 (.a(a[3]), .b(b[3]), .c_in(c3), .s(sum[3]), .c_out()); 
	
	wire c4, g3, p3, x3, x31, x32, pc3; 
	nand2 nand2_3 (.in1(a[3]), .in2(b[3]), .out(x3)); 
	not1 not1_3 (.in1(x3), .out(g3)); 
	xor2 xor2_3 (.in1(a[3]), .in2(b[3]), .out(p3)); 
	nand2 nand2_31 (.in1(p3), .in2(c3), .out(x31)); 
	not1 not1_31 (.in1(x31), .out(pc3)); 
	nor2 nor2_31 (.in1(g3), .in2(pc3), .out(x32)); 
	not1 not1_32 (.in1(x32), .out(c_out)); 
	
	//Group P = p0.p1.p2.p3
	wire y1, y2, y3; 
	nand3 nand3_p012 (.in1(p0), .in2(p1), .in3(p2), .out(y1)); 
	not1 not1_4 (.in1(y1), .out(y2)); 
	nand2 nand2_y2p3 (.in1(y2), .in2(p3), .out(y3));
	not1 not1_41 (.in1(y3), .out(p)); 

	//Group G = G3 + P3.G2 + P3.P2.G1 + P3.P2.P1.G0
	wire z1, z2, z3, z4, z5, z6, z7, z8, z9, z10;  
	//P3.G2
	nand2 nand2_p3g2 (.in1(p3), .in2(g2), .out(z1)); 
	not1 not1_5 (.in1(z1), .out(z2)); 
	//P3.P2.G1
	nand3 nand3_p3p2g1 (.in1(p3), .in2(p2), .in3(g1), .out(z3)); 
	not1 not1_51 (.in1(z3), .out(z4)); 
	//P3.P2.P1.G0
	nand3 nand3_p321 (.in1(p3), .in2(p2), .in3(p1), .out(z5)); 
	not1 not1_52 (.in1(z5), .out(z6)); 
	nand2 nand2_pg0 (.in1(z6), .in2(g0), .out(z7)); 
	not1 not1_53 (.in1(z7), .out(z8)); 
	//or the above
	nor3 nor3_p (.in1(z8), .in2(z4), .in3(z2), .out(z9)); 
	not1 not1_54 (.in1(z9), .out(z10)); 
	//or g3
	nor2 nor2_z8g3 (.in1(z10), .in2(g3), .out(z11)); 
	not1 not1_55(.in1(z11), .out(g)); 
	
	 
endmodule
