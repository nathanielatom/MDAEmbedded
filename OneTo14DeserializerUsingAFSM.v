/*
Anthony De Caria - March 17, 2014

This code implemenets a 1 to 14 bit de-serializer.
The data in the de-serializer is held using a shift register.
This code uses a FSM in order to make sure that the data is in the deserializer. 
However, this will reduce the speed of the data's release by a few clock cycles.

*/

module OneTo14DeserializerUsingAFSM(clock, resetn, ss, Ack, ready, data_in, data_out);
	//	Define the different I/Os	//
	
	//	General Inputs	//
	input clock;
	input resetn;
	
	//	Data I/O	//
	input data_in;
	output [13:0] data_out;
	
	//	FSM I/O		//
	input ss;
	input Ack;
	output ready;
	
	//	Debugging I/O	//
//	output reg [1:0] y_Q;
//	output reg [1:0] Y_D;
	
	/*
	FSM Parts
		Start / wait for data <------------------
		|										|
		|	negedge ss							|
		v										|
		Put data in the Shift Register			|
		|										|
		|	posedge ss							|
		v										|
		Done									|
		|										|
		|	Acknowledge = 1						|
		-----------------------------------------
	*/
	
	reg [1:0] y_Q, Y_D;
	parameter START = 2'b00, INPUT = 2'b01, DONE = 2'b10;
	
	always @(ss, Ack, y_Q)
	begin: state_table
		case (y_Q)
			START: if (!ss)
					Y_D = INPUT;
				else
					Y_D = START;
			INPUT: if (ss)
					Y_D = DONE;
				else
					Y_D = INPUT;
			DONE: if (Ack)
					Y_D = START;
				else
					Y_D = DONE;
			default: Y_D = 3'bxxx;
		endcase
	end // state_table
	
	//	Shift Register	//
	wire shiftRegEn;
	assign shiftRegEn = ~y_Q[1] & y_Q[0];
	
	assign ready = y_Q[1] & ~y_Q[0];
	
	ShiftRegisterWEnableFourteen Registeel(
											.clk(clock), 
											.resetn(resetn), 
											.enable(shiftRegEn), 
											.d(data_in), 
											.q(data_out)
											);
								
	always @(posedge clock or negedge resetn)
	begin: state_FFs
		if (resetn == 0)
			y_Q <= START;
		else
			y_Q <= Y_D;
	end // state_FFs

endmodule
