module HexDisp(numbers, HEX); // Convert special numbers to 7-segment
	input [3:0] numbers;
	output reg [0:6] HEX;
	
	always @(numbers) begin
		case(numbers)
			4'b0000: HEX = 7'b000_0001; // 0
			4'b0001: HEX = 7'b100_1111; // 1
			4'b0010: HEX = 7'b001_0010; // 2
			4'b0011: HEX = 7'b000_0110; // 3
			4'b0100: HEX = 7'b100_1100; // 4
			4'b0101: HEX = 7'b010_0100; // 5
			4'b0110: HEX = 7'b010_0000; // 6
			4'b0111: HEX = 7'b000_1111; // 7
			4'b1000: HEX = 7'b000_0000; // 8
			4'b1001: HEX = 7'b000_0100; // 9
			4'b1010: HEX = 7'b000_1000; // A
			4'b1011: HEX = 7'b001_1000; // P
			4'b1100: HEX = 7'b100_1110; // -/
			4'b1101: HEX = 7'b111_1000; // /-
			4'b1110: HEX = 7'b111_1110; // -
			default: HEX = 7'b111_1111; // blank
		endcase
	end
	
endmodule
