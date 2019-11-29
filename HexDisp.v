module HexDisp(numbers, HEX); // Convert special numbers to 7-segment
	input [3:0] numbers;
	output reg [6:0] HEX;
	
	always @(numbers) begin
		case(numbers)
			4'b0000: HEX = 7'b1000_000; // 0
			4'b0001: HEX = 7'b1111_001; // 1
			4'b0010: HEX = 7'b0100_100; // 2
			4'b0011: HEX = 7'b0110_000; // 3
			4'b0100: HEX = 7'b0011_001; // 4
			4'b0101: HEX = 7'b0010_010; // 5
			4'b0110: HEX = 7'b0000_010; // 6
			4'b0111: HEX = 7'b1111_000; // 7
			4'b1000: HEX = 7'b0000_000; // 8
			4'b1001: HEX = 7'b0010_000; // 9
			4'b1010: HEX = 7'b0001_000; // A
			4'b1011: HEX = 7'b0001_100; // P
			4'b1100: HEX = 7'b0111_001; // space ~ -/
			4'b1101: HEX = 7'b0001_111; // + ~ /-
			4'b1110: HEX = 7'b0111_111; // -
			default: HEX = 7'b1111_111; // blank
		endcase
	end
	
endmodule
