/*
Anthony De Caria - October 31, 2013

This module creates the SPI registers, for transmitting and recieveing.

RClk is the Register clock. 
It uses RS to change SCLK if required, 
as the D Flip Flop always runs on the posedge,
but it might have to run on negedge, depending on CPOL and CPHA.

(As a reminder, if RS = 0; the register runs on the negedge
and if RS = 1; the register runs on the posedge.)

Thus:
	If SCLK = 0 and RS = 0; RClk = 1
	If SCLK = 0 and RS = 1; RClk = 0
	If SCLK = 1 and RS = 0; RClk = 0
	If SCLK = 1 and RS = 1; RClk = 1
*/

module SPIRegister (SCLK, resetn, SS, RS, in, out);
	input SCLK;
	input resetn;
	input SS;
	input RS;
	input in;
	
	output out;
	
	wire RClk;
	
	assign RClk = ~(SCLK ^ RS);
	
	D_FF_with_Enable D(
								.clk(RClk), 
								.resetn(resetn), 
								.enable(SS), 
								.d(in), 
								.q(out)
							);
endmodule
