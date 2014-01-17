/*
Anthony De Caria

This module creates a Shift Register with a seperate enable signal.
*/

module ShiftRegisterWEnable(clk, resetn, enable, d, q);
	
	//Define the inputs and outputs
	input clk;
	input resetn;
	input enable;
	input d;
	output reg [3:0]q;
	
	D_FF_with_Enable Zero(clk, resetn, enable, d, q[0]);
	D_FF_with_Enable One(clk, resetn, enable, q[0], q[1]);
	D_FF_with_Enable Two(clk, resetn, enable, q[1], q[2]);
	D_FF_with_Enable Three(clk, resetn, enable, q[2], q[3]);
	
endmodule
