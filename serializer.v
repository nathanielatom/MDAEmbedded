module serializer(SW, KEY, LEDR, LEDG, HEX3, HEX2, HEX1, HEX0);
	
	input [9:0]SW;
	input [3:0]KEY;
	output [9:0]LEDR;
	output [7:0]LEDG;
	output [6:0]HEX3;
	output [6:0]HEX2;
	output [6:0]HEX1;
	output [6:0]HEX0;
	
	wire [15:0] registeel;
	wire [15:0] regigrab;
	
	assign regigrab[15] = SW[5];
	assign regigrab[14] = SW[5];
	assign regigrab[13] = SW[5];
	assign regigrab[12] = SW[5];
	assign regigrab[11] = SW[4];
	assign regigrab[10] = SW[4];
	assign regigrab[9] = SW[4];
	assign regigrab[8] = SW[4];
	assign regigrab[7] = SW[3];
	assign regigrab[6] = SW[3];
	assign regigrab[5] = SW[3];
	assign regigrab[4] = SW[3];
	assign regigrab[3] = SW[2];
	assign regigrab[2] = SW[2];
	assign regigrab[1] = SW[2];
	assign regigrab[0] = SW[2];
	
	SevenSegmentDisplayDecoder H3(HEX3, registeel[15:12]);
	SevenSegmentDisplayDecoder H2(HEX2, registeel[11:8]);
	SevenSegmentDisplayDecoder H1(HEX1, registeel[7:4]);
	SevenSegmentDisplayDecoder H0(HEX0, registeel[3:0]);
	
	SixteenTo1SerializerUsingAFSMwAsync Pileup_on_the_don_valley(.clock(KEY[0]), 
																					.resetn(KEY[1]),
																					.data_input(regigrab), 
																					.data_output(LEDR[9]),
																					.data_sent(LEDG[4]), 
																					.start(SW[0]), 
																					.data_loaded(LEDG[5]),
																					.ss(SW[1]), 
																					.counter_done(LEDG[6]), 
																					.y_Q(LEDG[1:0]), 
																					.Y_D(LEDG[3:2]),
																					.allOfDataOut(registeel),
																					.counter_start(LEDR[0]),
																					.muxSel(LEDG[7]),
																					.counter_bit(LEDR[4:1])
																					);
endmodule
