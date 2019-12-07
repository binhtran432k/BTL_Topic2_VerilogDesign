/** Mini Project Topic 2 - Digital Clock
 * 
 * Input: SW, KEY, CLOCK_50
 * Output: HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
 *         LEDR, LEDG
 * 
 * Testbench: MiniProjectTopic2_tb.v
 * Dependence: MainManager.v
 * 
 * Function: Assign pins of project to use for De2i - 150
 */
module MiniProjectTopic2(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, CLOCK_50, KEY, SW);
	input CLOCK_50;
	input [4:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR;
	output [7:0] LEDG;
	
	
	/** Assignment for LEDG[6:4] only to fix "Warning: Output pins are stuck at GND"
	 * but in fact they don't use in project.
	 */
	
	assign LEDG[6:4] = KEY == 0? 3'b111: 3'b000;
	
	
	/** Main Project Manager
	 * 
	 * Will explain more in MainManager.v 
	 * 
	 * HEX0 -> HEX7: Hex0 -> Hex7 - Fact: The 7-segments from 0 to 7, from right to left
	 * LEDG[7], LEDG[3:0]: SwiReverseDisp, ScreenDisp - Fact: The green leds
	 * LEDR: DayOfWeekDisp - Fact: The red leds
	 * CLOCK_50: clk - Fact: The clock with frequency 50_000_000 Hz
	 * KEY[0], KEY[1], KEY[2], KEY[3]: KeyEdit, KeyPlus, KeyMinus, KeySwi - Fact: The active low push buttons
	 * SW[0] -> SW[4]: DebugMinutes -> DebugYears - Fact: (Use for Debug) The switchs
	 */
	
	MainManager main(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDG[7], LEDG[3:0], LEDR, CLOCK_50,
						KEY[0], KEY[1], KEY[2], KEY[3],
						SW[0], SW[1], SW[2], SW[3], SW[4]);
endmodule
