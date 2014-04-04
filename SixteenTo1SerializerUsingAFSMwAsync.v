/*
Anthony De Caria - March 26, 2014

This code implemenets a 16 to 1 bit serializer.
The data in the serializer is stored into and released using a muxed shift register.
This code uses a FSM in order to make sure that the data is in the serializer. 
However, this will reduce the speed of the data's release by a few clock cycles.
This serializer has asyncoronous negative reset.
*/

module SixteenTo1SerializerUsingAFSMwAsync(clock, resetn, start, ss, data_input, data_sent, data_output, y_Q, Y_D, allOfDataOut);

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
	
	//	Debugging I/O	//
	output reg [1:0] y_Q;
	output reg [1:0] Y_D;
	output [15:0] allOfDataOut;
	
	//	Additional Wires	//
	wire muxSel;
	
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
		|	posedge ss						|
		|									|
		-------------------------------------
	*/
	
	//	Needed assignments	//
	assign data_sent = ~y_Q[0] & ~y_Q[1];
	assign muxSel = ~y_Q[0] & y_Q[1];
	assign data_out = allOfDataOut[0];
	
	//	The Shift Register	//
	ShiftRegisterWEnableSixteenAsyncMuxedInput CrashOnTheGardner(.clk(clock), .resetn(resetn), .enable(enable), .select(muxSel), .d(data_in), .q(allOfDataOut) );

	//	The FSM	//
	parameter START = 2'b00, LOAD = 2'b01, WAIT = 2'b10, SEND = 2'b11;
	
	always @(start, ss, y_Q)
	begin: state_table
		case (y_Q)
			START: 
				if (start)
					Y_D = INPUT;
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
				if (ss)
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
	
endmodule
