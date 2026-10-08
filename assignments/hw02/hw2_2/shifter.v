/*
    CS 147 Spring 26
    Homework #2, problem 1

    Barrel shifter implementation.
*/
module shifter (In, ShAmt, Oper, Out);

   // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

    //Mux for logical shift 
    //Chooses either 0 or the MSB of In depending on operation type. 
    wire logical_mux; 
     assign logical_mux = Oper[0] == 1 ? 0 : In[15]; 

    //Layer 1 
    //Muxes for shifting left or right
    //Choose either logical_mux + first 15 bits OR last 15 bits + logical_mux
    wire [15:0] right_mux;
    assign right_mux = Oper[1] == 1 ? {logical_mux,In[15:1]} : {In[14:0],logical_mux}; 
    //Mux for first layer (1 bit shift)
    wire [15:0] first_layer; 
    assign first_layer = ShAmt[0] == 1 ? right_mux : In; 

    //Layer 2 
    //Extend right mux for the next layer
    //Logical mux remains the same no matter what, rotate mux chooses depending on shift or rotate 
    wire [1:0] rotate_mux_2b; 
    assign rotate_mux_2b = Oper[0] == 1 ? 2'b0 : first_layer[15:14]; 
    wire [15:0] right_mux_2; 
    assign right_mux_2 = Oper[1] == 1 ? {{2{logical_mux}},first_layer[15:2]} : {first_layer[13:0],rotate_mux_2b}; 
    //Mux for second layer (2 bit shift for 3 total)
    wire [15:0] second_layer; 
    assign second_layer = ShAmt[1] == 1 ? right_mux_2 : first_layer;

    //Layer 3 
    //Extend right mux for the next layer
    wire [3:0] rotate_mux_4b; 
    assign rotate_mux_4b = Oper[0] == 1 ? 4'b0 : second_layer[15:12]; 
    wire [15:0] right_mux_3; 
    assign right_mux_3 = Oper[1] == 1 ? {{4{logical_mux}},second_layer[15:4]} : {second_layer[11:0],rotate_mux_4b}; 
    //Mux for third layer (4 bit shift for 7 total)
    wire [15:0] third_layer; 
    assign third_layer = ShAmt[2] == 1 ? right_mux_3 : second_layer;

    //Extend right mux for the next layer
    wire [7:0] rotate_mux_8b; 
    assign rotate_mux_8b = Oper[0] == 1 ? 8'b0 : third_layer[15:8]; 
    wire [15:0] right_mux_4; 
    assign right_mux_4 = Oper[1] == 1 ? {{8{logical_mux}},third_layer[15:8]} : {third_layer[7:0],rotate_mux_8b}; 
    //Mux for second layer (8 bit shift for 15 total)

    assign Out = ShAmt[3] == 1 ? right_mux_4 : third_layer;
	
	
endmodule
