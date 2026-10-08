/*
    CS 147 Spring 26
    Homework #2, problem 2

    Multi-bit ALU implementation.
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0

    //Inverse A and B?
	wire [15:0] A = invA == 1 ? ~InA : InA; 
	wire [15:0] B = invB == 1 ? ~InB : InB; 

	//CLA
	wire [15:0] cla_out; 
	wire unsigned_carryout; 
	cla_16b cla (.sum(cla_out), .c_out(unsigned_carryout), .a(A), .b(B), .c_in(Cin)); 
	//Check signed carryout 
	//Check AB same sign
	wire AB_same = ~(A[15] ^ B[15]);
	//Check the sum and A have different signs
	wire SumA_diff = A[15] ^ cla_out[15]; 
	//Check same sign and end with different signs --> overflow
	wire signed_c_out = AB_same & SumA_diff; 
	//Mux between signed and unsigned
	wire overflow = sign == 1 ? signed_c_out : unsigned_carryout; 

	//AND 
	wire [15:0] and_out = A & B; 

	//OR 
	wire [15:0] or_out = A | B;

	//XOR 
	wire [15:0] xor_out = A ^ B;

	//Shifter
	wire [15:0] shifter_out; 
	shifter shifter (.In(A), .ShAmt(B[3:0]), .Oper(Oper[1:0]), .Out(shifter_out)); 
	 
	//4_1 Mux for the simple operations
	//Mux between XOR and OR
	wire [15:0] mux_1 = Oper[0] == 1 ? xor_out : or_out; 
	//Mux between AND and ADD 
	wire [15:0] mux_0 = Oper[0] == 1 ? and_out : cla_out;
	//Mux between the two prior
	wire [15:0] mux_simple = Oper[1] == 1 ? mux_1 : mux_0; 


	//Mux between shift and simple operations
	assign Out = Oper[2] == 1 ? mux_simple : shifter_out; 
	
	assign Ofl = (Oper[2] == 1 & Oper[1] == 0 & Oper[0] == 0) ? overflow : 0; 
	assign Zero = Out == 0; 

	
	
    
endmodule
