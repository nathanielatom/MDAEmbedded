/*
Anthony De Caria - November 5, 2013

This module creates an SPI Master suite to be used for 
University of Toronto's Mechatronics Design Association’s robotic submarine AquaTux.

Janurary 12, 2013 Edit - Included a secondary MISO input in order to take the two input streams from the AD7264
*/
module AquaTuxSPIMaster(Clk, resetn, ss, CPOL, CPHA, SCLK, MOSI, MISOA, MISOB, SS, DIM, DOMA, DOMB)
	//Define the standard inputs
	input Clk;
	input resetn;
	
	//Define the smaller SPI related inputs
	input ss;
	input CPOL;
	input CPHA;
	
	//Define the Big SPI Four
	output SCLK;
	output MOSI;
	input MISOA;
	input MISOB;
	output SS;
	
	//Define the Master data streams
	input DIM;
	output DOMA;
	output DOMB;
	
	assign SS = ~ss;
	
	/*
	
	Master control signals
	
	*/
	
	//SCLK
	SCLKMaker TimeLord(
								.Clk(Clk), 
								.S(ss),
								.CPOL(CPOL),
								.SCLK(SCLK)
							 );
							 
	//RS
	SPIRSMaker DockWorker(
									.CPOL(CPOL), 
									.CPHA(CPHA), 
									.RS(RS)
								 );
	
	/*
	
	Master Registers
	
	The two registers run on opposite clock edges.
	*/
	
	//Transmitting Register
	SPIRegister TXRM(
							.SCLK(SCLK), 
							.resetn(resetn), 
							.SS(SS), 
							.RS(RS), 
							.in(DIM), 
							.out(MOSI)
						 );
	
	//Recieveing Registers
	SPIRegister RXRMA(
							.SCLK(SCLK), 
							.resetn(resetn), 
							.SS(SS), 
							.RS(RS), 
							.in(MISOA), 
							.out(DOMA)
						  );
						  
	SPIRegister RXRMB(
							.SCLK(SCLK), 
							.resetn(resetn), 
							.SS(SS), 
							.RS(RS), 
							.in(MISOB), 
							.out(DOMB)
						  );
	
endmodule
