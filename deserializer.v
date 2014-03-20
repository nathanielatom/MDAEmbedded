module deserializer (SW, KEY, LEDG, HEX0, HEX1);

	//	General I/O Ports	//
	
	input [2:0]SW;
	input [1:0]KEY;
	
	output [6:0]HEX0;
	output [6:0]HEX1;
	output [4:0]LEDG;
	
	//	Additional Wires	//
	
	wire [13:0]data_out;
	
	//	Call the Actual Deserializer	//
	
	OneTo14DeserializerUsingAFSM unown(
													.clock(KEY[0]), 
													.resetn(KEY[1]), 
													.ss(SW[1]), 
													.Ack(SW[2]), 
													.y_Q(LEDG[4:3]), 
													.Y_D(LEDG[2:1]), 
													.ready(LEDG[0]), 
													.data_in(SW[0]), 
													.data_out(data_out)
												);
												
	//	Assign the data_outs to the HEXs	//
	
	assign HEX0[6:0] = data_out[6:0];
	assign HEX1[6:0] = data_out[13:7];

endmodule
