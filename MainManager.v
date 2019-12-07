/** Main Project Manager
 * 
 * Input: clk,
 *        KeyEdit, KeyPlus, KeyMinus, KeySwi,
 *        DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears
 * Output: Hex0, Hex1, Hex2, Hex3, Hex4, Hex5, Hex6, Hex7,
 *         ScreenDisp, DayOfWeekDisp, SwiReverseDisp
 * 
 * Dependence: SecondCounter.v, MinuteCounter.v, HourCounter.v, Clk24toClk12.v,
 *             DayCounter.v, MonthCounter.v, YearCounter.v, DayOfWeekCounter.v,
 *             TimeZoneMinutes.v, TimeZoneHours.v, TimeZonePlusMinus.v,
 *             Mode24to12Signal,
 *             FlickerCounter.v, KeysManage.v, SwitchReverseSignal.v, ResetSignal.v, HexDisp.v
 * 
 * Function: Manage all function of project
 * 
 * Description Input, Output:
 *
 * - Hex0 -> Hex7: show the result of hours, days, timezone... to user
 * - SwiReverseDisp: perform switch is reversed
 * - ScreenDisp: perform current screen include 4 screen
 * - DayOfWeekDisp: perform current day of week
 * - clk: use for synchronize circuit, flip-flop
 * - KeyEdit: switch between Edit Mode and Normal Mode
 * - KeyPlus: adds 1 to current position of screen if user is in Edit
 *            Mode else it brings user to next screen
 * - KeyMinus: subtracts 1 from current position of screen if user is in
 *             Edit Mode else it brings user back previous screen
 * - KeySwi: switch to next position (from left to
 *           right) when user is in Edit Mode
 * - DebugMinutes -> DebugYears: use for Debug
 */
module MainManager(Hex0, Hex1, Hex2, Hex3, Hex4, Hex5, Hex6, Hex7, SwiReverseDisp, ScreenDisp, DayOfWeekDisp, clk,
						KeyEdit, KeyPlus, KeyMinus, KeySwi,
						DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears);
	input clk,
			KeyEdit, KeyPlus, KeyMinus, KeySwi,
			DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears;
	output reg [6:0] Hex0, Hex1, Hex2, Hex3, Hex4, Hex5, Hex6, Hex7;
	output [3:0] ScreenDisp;
	output [6:0] DayOfWeekDisp;
	output SwiReverseDisp;
	
	// Wire use for project: Will explain more in suitable function
	
	wire[6:0] seconds, minutes, hours, days, months, TZMinutes, TZHours, DayNight, hours12;
	wire[14:0] years;
	wire [6:0] Hex2Src1, Hex3Src1, Hex4Src1, Hex5Src1, Hex6Src1, Hex7Src1,
													Hex0Src1_2, Hex6Src1_2, Hex7Src1_2,
				Hex0Src2, Hex1Src2, Hex2Src2, Hex3Src2, Hex4Src2, Hex5Src2, Hex6Src2, Hex7Src2,
				Hex2Src3, Hex3Src3, Hex4Src3, Hex5Src3, Hex6Src3, Hex7Src3,
				Hex2Src4, Hex3Src4;
	wire [1:0] screen;
	wire EditMode, ClkFlick, ClkHour, ClkMinute, ClkDay, ClkMonth, ClkYear, ClkLeap, TZPlusMinus,
			HourOverMinus, HourOverPlus,
			DayOverMinus, DayOverPlus,
			MonthOverMinus, MonthOverPlus,
			YearOverMinus, YearOverPlus,
			reset, SwiReverse, Mode24t12;
	wire [2:0] EditPos, DayOfWeek;
	
	
	// Screen 1: Manage Hours, Minutes, Seconds
	
	
	// Seconds Manager: Explain more in SecondCounter.v
	SecondCounter second(seconds, ClkMinute, clk,
						DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears,
						KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	// 7-Segment Converter: Explain more in HexDisp.v
	HexDisp unitSeconds(seconds % 10, Hex2Src1);
	HexDisp tensSeconds(seconds / 10, Hex3Src1);
	
	
	// Minutes Manager: Explain more in MinuteCounter.v
	MinuteCounter minute(minutes, ClkHour, HourOverPlus, HourOverMinus,
							ClkMinute, clk, KeyPlus, KeyMinus, reset,
							EditPos, EditMode, screen,
							TZMinutes);
	HexDisp unitMinutes(minutes % 10, Hex4Src1);
	HexDisp tensMinutes(minutes / 10, Hex5Src1);

	
	// Hours Manager: Explain more in HourCounter.v
	HourCounter hour24(hours, ClkDay, DayOverPlus, DayOverMinus,
						ClkHour, clk, KeyPlus, KeyMinus, reset,
						Mode24t12, EditPos, EditMode, screen, HourOverPlus, HourOverMinus,
						TZPlusMinus, TZHours);
	HexDisp unitHours24(hours % 10, Hex6Src1);
	HexDisp tensHours24(hours / 10, Hex7Src1);
	
	
	// Clock 12 Converter:  Explain more in Clk24toClk12.v
	Clk24toClk12 hour12(hours12, DayNight, hours);
	HexDisp dayNightDisp(DayNight, Hex0Src1_2);
	HexDisp unitHours12(hours12 % 10, Hex6Src1_2);
	HexDisp tensHours12(hours12 / 10, Hex7Src1_2);
	
	
	// Screen 2: Manage Days, Months, Years, Day Of Week
	
	
	// Days Manager: Explain more in DayCounter.v
	DayCounter day(days, ClkLeap, MonthOverPlus, MonthOverMinus,
						ClkMonth, ClkDay, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, DayOverPlus, DayOverMinus,
						months);
	HexDisp unitDays(days % 10, Hex6Src2);
	HexDisp tensDays(days / 10, Hex7Src2);
	
	
	// Months Manager: Explain more in MonthCounter.v
	MonthCounter month(months, ClkYear, YearOverPlus, YearOverMinus,
						ClkMonth, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, MonthOverPlus, MonthOverMinus);
	HexDisp unitMonths(months % 10, Hex4Src2);
	HexDisp tensMonths(months / 10, Hex5Src2);

	
	// Years Manager: Explain more in YearCounter.v
	YearCounter year(years, ClkLeap,
						ClkYear, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, YearOverPlus, YearOverMinus);
	HexDisp unitYears(years % 10, Hex0Src2);
	HexDisp tensYears((years / 10) % 10, Hex1Src2);
	HexDisp hundredYears((years / 100) % 10, Hex2Src2);
	HexDisp thousandYears((years / 1000) % 10, Hex3Src2);
	
	
	// Day Of Week Manager: Explain more in DayOfWeekCounter.v
	DayOfWeekCounter dayOfWeek(DayOfWeek, days, months, years, ClkLeap);


	// Screen 3: Manage TimeZone
	
	
	// Time Zone Minutes Manager: Explain more in TimeZoneMinutes.v
	TimeZoneMinutes TZminute(TZMinutes, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	HexDisp unitTZMinutes(TZMinutes % 10, Hex2Src3);
	HexDisp tensTZMinutes(TZMinutes / 10, Hex3Src3);
	
	
	// Time Zone Hours Manager: Explain more in TimeZoneHours.v
	TimeZoneHours TZhour(TZHours, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen, TZPlusMinus);
	HexDisp unitTZHours(TZHours % 10, Hex4Src3);
	HexDisp tensTZHours(TZHours / 10, Hex5Src3);
	
	
	// Time Zone Plus Minus Manager: Explain more in TimeZonePlusMinus.v
	TimeZonePlusMinus TZPlusMinusSignal(TZPlusMinus, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen, TZHours);
	assign Hex6Src3 = TZPlusMinus == 1? 7'b000_1111: 7'b011_1111;
	assign Hex7Src3 = TZPlusMinus == 1? 7'b011_1001: 7'b111_1111;
	
	
	// Screen 4: Manage Mode24t12 Signal
	
	
	// Mode 12h or 24h Manager: Explain more in Mode24to12Signal.v
	Mode24to12Signal Mod24t12Sig(Mode24t12,
								clk, screen, EditMode, reset,
								KeyPlus, KeyMinus);
	assign Hex2Src4 = Mode24t12 == 1? 7'b010_0100: 7'b001_1001; // 1 - 2
	assign Hex3Src4 = Mode24t12 == 1? 7'b111_1001: 7'b010_0100; // 2 - 4


	// Manage Mode, Screen, Keys and Signals
	
	
	// Basic Signal Manager: Explain more in KeysManage.v
	KeysManage KeyScrMod(EditMode, screen, EditPos, KeyPlus, KeyMinus, KeyEdit, KeySwi, Mode24t12, SwiReverse, clk, reset);
	
	
	// Switch Reverse Manager: Explain more in SwitchReverseSignal.v
	SwitchReverseSignal SwiRevSig(SwiReverse, KeySwi, clk, EditMode, reset);


	// Reset Manager: Explain more in ResetSignal.v
	ResetSignal reSig(reset, KeyEdit, clk);
	
	
	// Flicker Effect Clock: Explain more in FlickerCounter.v
	FlickerCounter fc0(ClkFlick, clk, reset);
	
	
	// Display Result to User


	// Display Switch Reverse, the first condition only to fix "Warning: Output pins are stuck at GND"
	assign SwiReverseDisp = (KeyEdit == 0 && KeyMinus == 0 && KeyPlus == 0 && KeySwi == 0)? 1'b1:
							(reset == 0 || SwiReverse == 0 || EditMode == 0)? 1'b0: 1'b1;


	// Display Screen
	assign ScreenDisp = ((reset == 0) || (EditMode == 1 && ClkFlick == 1))? 4'b0000:
					(screen == 0)? 4'b0001: // Hour Mode
					(screen == 1)? 4'b0011: // Day Mode
					(screen == 2)? 4'b0111: 4'b1111; // Time Zone Mode - 12h Mode


	// Display Day Of Week
	assign DayOfWeekDisp = (reset == 0)? 7'b000_0000:
								(DayOfWeek == 0)? 7'b100_0000: // Sunday
								(DayOfWeek == 1)? 7'b000_0011: // Monday
								(DayOfWeek == 2)? 7'b000_0111: // TuesDay
								(DayOfWeek == 3)? 7'b000_1111: // Wednesday
								(DayOfWeek == 4)? 7'b001_1111: // Thursday
								(DayOfWeek == 5)? 7'b011_1111: 7'b111_1111; // Friday - Saturday


	// Display 7-segments belong to screen, include in Hour, Day, Time Zone, 12h Mode
	always @(posedge clk) begin
		// When Power On
		if(reset) begin
			// Hour Mode
			if (screen == 0) begin
				if (Mode24t12 == 0) begin
					Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex7Src1;
					Hex6 <= (EditMode == 1 && EditPos == 1 && ClkFlick == 1)? 7'b111_1111: Hex6Src1;
					Hex0 <= 7'b111_1111; // blank
				end
				else begin
					Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex7Src1_2;
					Hex6 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex6Src1_2;
					Hex0 <= (EditMode == 1 && EditPos == 7 && ClkFlick == 1)? 7'b111_1111: Hex0Src1_2;
				end
				Hex5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: Hex5Src1;
				Hex4 <= (EditMode == 1 && EditPos == 3 && ClkFlick == 1)? 7'b111_1111: Hex4Src1;
				Hex3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b111_1111: Hex3Src1;
				Hex2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b111_1111: Hex2Src1;
				Hex1 <= 7'b111_1111; // blank
			end
			// Day Mode
			else if (screen == 1) begin
				Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex7Src2;
				Hex6 <= (EditMode == 1 && EditPos == 1 && ClkFlick == 1)? 7'b111_1111: Hex6Src2;
				Hex5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: Hex5Src2;
				Hex4 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: Hex4Src2;
				Hex3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b111_1111: Hex3Src2;
				Hex2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b111_1111: Hex2Src2;
				Hex1 <= (EditMode == 1 && EditPos == 6 && ClkFlick == 1)? 7'b111_1111: Hex1Src2;
				Hex0 <= (EditMode == 1 && EditPos == 7 && ClkFlick == 1)? 7'b111_1111: Hex0Src2;
			end
			// Time Zone Mode
			else if (screen == 2) begin
				Hex7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex7Src3;
				Hex6 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: Hex6Src3;
				Hex5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: Hex5Src3;
				Hex4 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: Hex4Src3;
				Hex3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b111_1111: Hex3Src3;
				Hex2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b111_1111: Hex2Src3;
				Hex1 <= 7'b111_1111; // blank
				Hex0 <= 7'b111_1111; // blank
			end
			// 12h Mode
			else begin
				Hex7 <= 7'b111_1111; // blank
				Hex6 <= 7'b111_1111; // blank
				Hex5 <= (EditMode == 1 && ClkFlick == 1)? 7'b111_1111: 7'b011_0011;
				Hex4 <= (EditMode == 1 && ClkFlick == 1)? 7'b111_1111: 7'b010_0111;
				Hex3 <= (EditMode == 1 && ClkFlick == 1)? 7'b111_1111: Hex3Src4;
				Hex2 <= (EditMode == 1 && ClkFlick == 1)? 7'b111_1111: Hex2Src4;
				Hex1 <= 7'b111_1111; // blank
				Hex0 <= (EditMode == 1 && ClkFlick == 1)? 7'b111_1111: 7'b111_0110;
			end
		end
		// When Power Off
		else begin
			Hex7 <= 7'b111_1111; // blank
			Hex6 <= 7'b111_1111; // blank
			Hex5 <= 7'b111_1111; // blank
			Hex4 <= 7'b111_1111; // blank
			Hex3 <= 7'b111_1111; // blank
			Hex2 <= 7'b111_1111; // blank
			Hex1 <= 7'b111_1111; // blank
			Hex0 <= 7'b111_1111; // blank
		end
	end
	
endmodule
