/*
    CS 147 Spring 26
    Homework #3, problem 1

    Parameterized N-bit register built from DFFs.
*/
// Shared via symlink between assignments/hw03/hw3_1/register.v and assignments/hw03/hw3_2/register.v.
// WARNING: This file can be edited from either path, but DO NOT move or duplicate this file.
module register (
                 // Outputs
                 q, err,
                 // Inputs
                 clk, rst, en, d
                 );

   parameter WIDTH = 16;

   input              clk, rst, en;
   input  [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   output             err;

   /* YOUR CODE HERE */
	
	wire [WIDTH-1:0] write = en? d : q; 
	
	dff_4b dff_4b_0 (.q(q[3:0]), .d(write[3:0]), .clk(clk), .rst(rst));
	dff_4b dff_4b_1 (.q(q[7:4]), .d(write[7:4]), .clk(clk), .rst(rst));
	dff_4b dff_4b_2 (.q(q[11:8]), .d(write[11:8]), .clk(clk), .rst(rst));
	dff_4b dff_4b_3 (.q(q[15:12]), .d(write[15:12]), .clk(clk), .rst(rst));
	
	assign err = (^{d, en}) === 1'bx;
	

endmodule
