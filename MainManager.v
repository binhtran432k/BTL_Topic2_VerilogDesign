/**
 * 
 */
module MainManager(Hex0, Hex1, Hex2, Hex3, Hex4, Hex5, Hex6, Hex7, ScreenDisp, clk,
						KeyEdit, KeyPlus, KeyMinus, KeySwi,
						reset, DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears, SwiReverse, Mode24t12);
	input clk,
			KeyEdit, KeyPlus, KeyMinus, KeySwi,
			reset, DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears, SwiReverse, Mode24t12;
	output reg [6:0] Hex0, Hex1, Hex2, Hex3, Hex4, Hex5, Hex6, Hex7;
	output [2:0] ScreenDisp;
	
	
	wire[5:0] seconds, minutes, days, months;
	wire [4:0] hours;
	wire[14:0] years;
	wire [3:0] DayNight, hours12;
	wire [6:0] Hex2Src1, Hex3Src1, Hex4Src1, Hex5Src1, Hex6Src1, Hex7Src1,
													Hex0Src1_2, Hex6Src1_2, Hex7Src1_2,
				Hex0Src2, Hex1Src2, Hex2Src2, Hex3Src2, Hex4Src2, Hex5Src2, Hex6Src2, Hex7Src2;
	wire [1:0] screen;
	wire EditMode, ClkFlick, ClkHour, ClkMinute, ClkDay, ClkMonth, ClkYear, ClkLeap;
	wire [2:0] EditPos;
	
	
	FlickerCounter fc0(ClkFlick, clk, reset);
	
	
	// Screen 1: Manage Hours, Minutes, Seconds
	
	
	SecondCounter second(seconds, ClkMinute, clk,
						DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears,
						KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitSeconds(seconds % 10, Hex2Src1);
	HexDisp tensSeconds(seconds / 10, Hex3Src1);
	
	
	MinuteCounter minute(minutes, ClkHour, ClkMinute, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitMinutes(minutes % 10, Hex4Src1);
	HexDisp tensMinutes(minutes / 10, Hex5Src1);

	
	HourCounter hour24(hours, ClkDay, ClkHour, clk, KeyPlus, KeyMinus, reset, Mode24t12, EditPos, EditMode, screen);
	HexDisp unitHours24(hours % 10, Hex6Src1);
	HexDisp tensHours24(hours / 10, Hex7Src1);
	
	
	Clk24toClk12 hour12(hours12, DayNight, hours);
	HexDisp dayNightDisp(DayNight, Hex0Src1_2);
	HexDisp unitHours12(hours12 % 10, Hex6Src1_2);
	HexDisp tensHours12(hours12 / 10, Hex7Src1_2);
	
	
	// Screen 2: Manage Days, Months, Years
	
	
	DayCounter day(days, ClkMonth, ClkDay, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitDays(days % 10, Hex6Src2);
	HexDisp tensDays(days / 10, Hex7Src2);
	
	
	MonthCounter month(months, ClkYear, ClkMonth, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitMonths(months % 10, Hex4Src2);
	HexDisp tensMonths(months / 10, Hex5Src2);

	
	YearCounter year(years, ClkLeap, ClkYear, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitYears(years % 10, Hex0Src2);
	HexDisp tensYears((years / 10) % 10, Hex1Src2);
	HexDisp hundredYears((years / 100) % 10, Hex2Src2);
	HexDisp thousandYears((years / 1000) % 10, Hex3Src2);
	
	
	// Manage Mode, screen and Keys
	
	
	KeysManage KeyScrMod(EditMode, screen, EditPos, KeyPlus, KeyMinus, KeyEdit, KeySwi, Mode24t12, SwiReverse, clk, reset);
	
	
	// Display screen
	
	
	assign ScreenDisp = reset == 0? 3'b000:
					(screen == 0)? 3'b100: // Normal Mode
					(screen == 1)? 3'b110: // DayMonth Mode
					(screen == 2)? 3'b111: 3'b000; // TimeZone Mode __ Unknown Mode
	
	// Detect signals to control 7-segment display
	
	always @(*) begin
		if(reset) begin
			if (screen == 0) begin
				if (Mode24t12 == 0) begin
					Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b1111_111: Hex7Src1;
					Hex6 <= (EditMode == 1 && EditPos == 1 && ClkFlick == 1)? 7'b1111_111: Hex6Src1;
					Hex0 <= 7'b1111_111; // blank
				end
				else begin // when in 12h mode
					Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b1111_111: Hex7Src1_2; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
					Hex6 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b1111_111: Hex6Src1_2; // ...
					Hex0 <= (EditMode == 1 && EditPos == 7 && ClkFlick == 1)? 7'b1111_111: Hex0Src1_2; // ...
				end
				// Common elements of 12h and 24h mode
				Hex5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b1111_111: Hex5Src1; // ...
				Hex4 <= (EditMode == 1 && EditPos == 3 && ClkFlick == 1)? 7'b1111_111: Hex4Src1; // ...
				Hex3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b1111_111: Hex3Src1; // ...
				Hex2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b1111_111: Hex2Src1; // ...
				Hex1 <= 7'b1111_111; // blank
			end
			else if (screen == 1) begin // In DayMonth Mode
				Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b1111_111: Hex7Src2; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
				Hex6 <= (EditMode == 1 && EditPos == 1 && ClkFlick == 1)? 7'b1111_111: Hex6Src2; // ...
				Hex5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b1111_111: Hex5Src2; // ...
				Hex4 <= (EditMode == 1 && EditPos == 3 && ClkFlick == 1)? 7'b1111_111: Hex4Src2; // ...
				Hex3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b1111_111: Hex3Src2; // ...
				Hex2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b1111_111: Hex2Src2; // ...
				Hex1 <= (EditMode == 1 && EditPos == 6 && ClkFlick == 1)? 7'b1111_111: Hex1Src2; // ...
				Hex0 <= (EditMode == 1 && EditPos == 7 && ClkFlick == 1)? 7'b1111_111: Hex0Src2; // ...
			end
			else if (screen == 2) begin // In TimeZone Mode
				Hex7 <= 7'b0111_001; // space ~ -/
				Hex6 <= 7'b0001_111; // + ~ /-
				Hex5 <= 7'b1000_000; // 0
				Hex4 <= 7'b1111_000; // 7
				Hex3 <= 7'b1000_000; // 0
				Hex2 <= 7'b1000_000; // 0
				Hex1 <= 7'b1111_111; // blank
				Hex0 <= 7'b1111_111; // blank
			end
		end
		else begin
			Hex7 <= 7'b1111_111; // blank
			Hex6 <= 7'b1111_111; // blank
			Hex5 <= 7'b1111_111; // blank
			Hex4 <= 7'b1111_111; // blank
			Hex3 <= 7'b1111_111; // blank
			Hex2 <= 7'b1111_111; // blank
			Hex1 <= 7'b1111_111; // blank
			Hex0 <= 7'b1111_111; // blank
		end
	end
	
endmodule
