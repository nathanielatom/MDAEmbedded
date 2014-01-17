/*
Anthony De Caria - November 18, 2013

This module takes in a 50 MegaHertz clock,
and outputs a 5 MegaHertz clock.

*/

module FiftyMegaHzToFiveMegaHz (FiftyIn, FiveOut);
	//Define the inputs and outputs
	input FiftyIn;
	output FiveOut;
	
	//Create the internal Registers and Parameters
	reg [3:0] counter = 4'b0000;
	reg out = 1'b0;
	parameter cap = 4'd10;
	
	always@(posedge FiftyIn)
	begin
		if (counter < cap)
		begin
			counter <= counter + 4'b0001;
			out <= out;
		end
		else
		begin
			counter <= 4'b0000;
			out <= !out;
		end
	end
	
	assign FiveOut = out;
	
endmodule
