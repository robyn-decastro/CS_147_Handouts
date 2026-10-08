
module dff_4b (
            // Output
            q,
            // Inputs
            d, clk, rst
            );

    output         [3:0] q;
    input          [3:0] d;
    input          clk;
    input          rst;

	dff dff1(.q(q[0]), .d(d[0]), .clk(clk), .rst(rst)); 
	dff dff2 (.q(q[1]), .d(d[1]), .clk(clk), .rst(rst)); 
	dff dff3 (.q(q[2]), .d(d[2]), .clk(clk), .rst(rst)); 
	dff dff4 (.q(q[3]), .d(d[3]), .clk(clk), .rst(rst)); 

endmodule