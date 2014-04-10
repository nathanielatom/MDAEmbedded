/*
Anthony De Caria - March 26, 2014

This code implemenets a 16 to 1 bit serializer.
The data in the serializer is stored into and released using a muxed shift register.
This code uses a FSM in order to make sure that the data is in the serializer. 
However, this will reduce the speed of the data's release by a few clock cycles.
This serializer has asyncoronous negative reset.
*/

module SixteenTo1SerializerUsingAFSMwAsync(clock, resetn, start, ss, data_input, data_sent, counter_start, muxSel, data_output, y_Q, Y_D, allOfDataOut);

	//	I/O Definations	//
	
	//	General I/Os	//
	input clock;
	input resetn;
	
	//	Data I/Os	//
	input [15:0]data_input;
	output data_output;
	
	//	State changing I/Os	//
	input start;
	input ss;
	output data_sent;
	output counter_start;
	
	//	Debugging I/O	//
	output reg [1:0] y_Q;
	output reg [1:0] Y_D;
	output muxSel;
	output [15:0] allOfDataOut;
	
	//	Additional Wires	//
	wire muxSel, counter_done;
	wire [3:0] counter_bit;
	
	/*
		FSM States
		
		Start / Idle <-----------------------
		|									|
		|	start							|
		v									|
		Load								|
		|									|
		|									|
		v									|
		Wait								|
		|									|
		|	nededge ss						|
		v									|
		Send								|
		|									|
		|	counter_done					|
		|									|
		-------------------------------------
	*/

	//	The FSM	//
	parameter START = 2'b00, LOAD = 2'b01, WAIT = 2'b10, SEND = 2'b11;
	
	always @(start, ss, counter_done, y_Q)
	begin: state_table
		case (y_Q)
			START: 
				if (start)
					Y_D = LOAD;
				else
					Y_D = START;
			LOAD: 
				Y_D = WAIT;
			WAIT: 
				if (!ss)
					Y_D = SEND;
				else
					Y_D = WAIT;
			SEND: 
				if (counter_done)
					Y_D = START;
				else
					Y_D = SEND;
			default: Y_D = 3'bxxx;
		endcase
	end // state_table
		
	always @(posedge clock or negedge resetn)
	begin: state_FFs
		if (resetn == 0)
			y_Q <= START;
		else
			y_Q <= Y_D;
	end // state_FFs
	
		//	Needed assignments	//
	assign data_sent = ~y_Q[1] & ~y_Q[0];
	assign muxSel = ~y_Q[1] & y_Q[0];
	assign counter_start = y_Q[1] & y_Q[0];
	assign data_out = allOfDataOut[15];
	
	assign counter_done = counter_bit[3] & counter_bit[2] & counter_bit[1] & counter_bit[0];
	
	//	The Counter	//
	FourBitCounterAsync TheClockKing (
										.clk(clock),
										.resetn(resetn),
										.enable(counter_start),
										.q(counter_bit)
									);
	
	//	The Shift Register	//
	ShiftRegisterWEnableSixteenAsyncMuxedInput CrashOnTheGardner(
																	.clk(clock), 
																	.resetn(resetn), 
																	.enable(y_Q[0]), 
																	.select(muxSel), 
																	.d(data_in), 
																	.q(allOfDataOut) 
																);
	
endmodule
