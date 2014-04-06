/*
Anthony De Caria - November 5, 2013

This module creates an SPI Master suite to be used for 
University of Toronto's Mechatronics Design Association’s robotic submarine AquaTux.

Janurary 12, 2013 Edit - Included a secondary MISO input in order to take the two input streams from the AD7264.
March 20, 2014 Edit - Made the registers have an asyncronous reset.
April 5, 2014 Edit - Added a tri-state buffer to the Transmitter register; Included a new register to slow the SS by one cycle.
*/
module AquaTuxSPIMaster(Clk, resetn, ss, startSending, CPOL, CPHA, SCLK, MOSI, MISOA, MISOB, SS, DIM, DOMA, DOMB);
	//	I/Os	//
	
	//Define the standard inputs
	input Clk;
	input resetn;
	
	//Define the smaller SPI related inputs
	input ss;
	input CPOL;
	input CPHA;
	input startSending;
	
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
	
	//	Internal Wires	//
	
	wire masterSS, TX;
	
	//	Early Assignments	//
	
	assign masterSS = ~ss;
	
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
	
	The AD7264 will read data on the negedge, thus we have to send data on the posedge.
	The AD7264 will send data on the negedge, thus we have to read the data on the posedge.
	As such, all of the registers are running on the same edge.
	
	*/
	
	//Transmitting Register
	SPIRegister TXRM(
						.SCLK(SCLK), 
						.resetn(resetn), 
						.SS(masterSS), 
						.RS(RS), 
						.in(DIM), 
						.out(TX)
					);
	
	//Recieveing Registers
	SPIRegister RXRMA(
						.SCLK(SCLK), 
						.resetn(resetn), 
						.SS(masterSS), 
						.RS(RS), 
						.in(MISOA), 
						.out(DOMA)
					  );
						  
	SPIRegister RXRMB(
						.SCLK(SCLK), 
						.resetn(resetn), 
						.SS(masterSS), 
						.RS(RS), 
						.in(MISOB), 
						.out(DOMB)
					  );
						  
	/*
	
	SS Register
	
	Because the AD7264 reads the transmitter register on the first negedge after SS goes down,
	and because the transmitter register requires a clock cycle to receive the data from DIM,
	SS will be clocked one cycle slower.
	
	*/
	D_FF_Async SSShift(
						.clk(SCLK), 
						.resetn(resetn),  
						.d(masterSS), 
						.q(SS)
						);
	
	/*
	
	Tri-state Buffer
	
	The AD7264 only expects data from the Master for only 16 clock cycles. 
	While one can assume the AD7264 can ignore any additional data, it's safer if we block the signal on our end.
	This code assumes that additional control logic outside of the master will control when the tri-state buffer is on.
	
	*/
	
	TriStateBuffer Send(
							.In(TX)
							.Select(startSending)
							.Out(MOSI)
						);
	
endmodule
