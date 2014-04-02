/*
Anthony De Caria - March 26, 2014

This code implemenets a 1 to 14 bit serializer.
The data in the serializer be passed to and released using a shift register.
This code uses a FSM in order to make sure that the data is in the serializer. 
However, this will reduce the speed of the data's release by a few clock cycles.
This serializer has asyncoronous negative reset.
*/

module FourteenTo1SerializerUsingAFSMwAsync(clock, resetn, start, ss, data_input, data_sent, data_output);

	//	I/O Definations	//
	
	//	General I/Os	//
	input clock;
	input resetn;
	
	//	Data I/Os	//
	input [13:0]data_input;
	output data_output;
	
	//	State changing I/Os	//
	input start;
	input ss;
	output data_sent;
	
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
	
	//	Create the counter	//

endmodule
