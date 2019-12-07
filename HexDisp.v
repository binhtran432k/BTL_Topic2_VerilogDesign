/** 7-Segment Converter
 * 
 * Input: numbers
 * Output: HEX
 * 
 * Dependence: none
 * 
 * Function: convert from decimal to 7-Segment for display Minutes Manager
 * 
 * Description Input, Output:
 * 
 * - numbers: the numbers in decimal
 * - HEX: the result for 7-segment
 */
module HexDisp(numbers, HEX);
	input [3:0] numbers;
	output reg [6:0] HEX;
	
	always @(numbers) begin
		case(numbers)
			4'b0000: HEX = 7'b100_0000; // 0
			4'b0001: HEX = 7'b111_1001; // 1
			4'b0010: HEX = 7'b010_0100; // 2
			4'b0011: HEX = 7'b011_0000; // 3
			4'b0100: HEX = 7'b001_1001; // 4
			4'b0101: HEX = 7'b001_0010; // 5
			4'b0110: HEX = 7'b000_0010; // 6
			4'b0111: HEX = 7'b111_1000; // 7
			4'b1000: HEX = 7'b000_0000; // 8
			4'b1001: HEX = 7'b001_0000; // 9
			4'b1010: HEX = 7'b000_1000; // A
			4'b1011: HEX = 7'b000_1100; // P
			4'b1100: HEX = 7'b011_1001; // space ~ -/
			4'b1101: HEX = 7'b000_1111; // + ~ /-
			4'b1110: HEX = 7'b011_1111; // -
			default: HEX = 7'b111_1111; // blank
		endcase
	end
	
endmodule
