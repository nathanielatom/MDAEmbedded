/*
Adam Suban-Loewen and Anthony De Caria - November 23, 2013

The module takes in a high clock signal and outputs a lower clock signal.

There is a counter created at the beginning equaling one. 
At each posedge of high clock, we check to see if the counter equals the higher frequency divied by the lower frequency.
If it does:		we reset the counter and turn the lower frequency clock into the opposite it was before.
Else:				we add the counter by one and keep the lower frequency clock the same.

Since the DE0 is a 32 bit system, we assume the frequencies are 32 bits at the most.
*/

module HighClockToLowClock(HighClock, HighFreq, LowFreq, LowClock);
	//Define the I/Os
	input HighClock;
	input [31:0] HighFreq;
	input [31:0] LowFreq;
	output reg LowClock;
	
	// Create the required wires
	integer counter = 32'h00000000;
	wire [31:0] cap;
	
	assign cap = HighFreq / LowFreq;
	
	always@(posedge HighClock)
	begin
		if (counter == cap)
		begin
			counter <= 32'h00000000;
			LowClock <= !LowClock;
		end
		else
		begin
			counter <= counter + 32'h00000001;
			LowClock <= LowClock;
		end
	end
	
endmodule
