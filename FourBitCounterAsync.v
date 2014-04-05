/*
Anthony De Caria - April 5, 2014

This is a Four Bit Asyncronous Counter.
*/

module FourBitCounterAsync(clk, resetn, enable, q);
	
	input clk;
	input resetn;
	input enable;
	output [3:0]q;
	
	T_FF_with_Enable_Async Three(clk, resetn, enable, q[3]);
	T_FF_with_Enable_Async Two(clk, resetn, enable, q[2]);
	T_FF_with_Enable_Async One(clk, resetn, enable, q[1]);
	T_FF_with_Enable_Async Zero(clk, resetn, enable, q[0]);
	
endmodule
