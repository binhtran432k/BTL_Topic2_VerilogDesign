module MiniProjectTopic2(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50, KEY, SW);
	input CLOCK_50; // 1 Clock frequency 50_000_000 Hz
	input [2:0] SW; // 3 Switch to perform special function
	input [3:0] KEY; // 4 Push buttons to control the clock
	output reg [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7; // Real 7-Segment
	output [2:0] LEDR; // 3 Leds to perform View Mode
	
	wire[5:0] seconds, minutes, hours, dayNight, hours2; // Value of time, day, time zone,...
	wire [0:6] HEX2A, HEX3A, HEX4A, HEX5A, HEX6A, HEX7A, //Fake 7-Segment in Normal Mode in 12h
				HEX0A2, HEX6A2, HEX7A2, //Fake 7-Segment in Normal Mode in 24h
				HEXF; //Fake Hex to perform blank
	wire [1:0] disMode; // Perform 3 view mode
	wire editMode, clkFlick, clkHour, clkMinute; // Perform Edit Mode is on __ Perform Clock for flicker 7-segment
	wire [2:0] editCur; // The current Position of edit value
	
	FlickerCounter fc0(clkFlick, CLOCK_50); // Convert CLOCK_50 to clock for flicker 7-segment
	
	//For Seconds Counter

	SecondCounter s0(seconds, clkMinute, CLOCK_50, KEY, editCur, editMode, disMode, SW[0]); // Manage Seconds
	HexDisp uS(seconds % 10, HEX2A); // Convert units of seconds to 7-segment
	HexDisp tS(((seconds - (seconds % 10)) / 10) % 10, HEX3A); // Convert tens of seconds to 7-segment
	
	//For Minutes Counter

	MinuteCounter m0(minutes, clkHour, clkMinute, KEY, editCur, editMode, disMode); // Manage Minutes
	HexDisp uM(minutes % 10, HEX4A); // Convert units of minutes to 7-segment
	HexDisp tM(((minutes - (minutes % 10)) / 10) % 10, HEX5A); // Convert tens of minutes to 7-segment
	
	//For Hours Counter in 24h mode

	HourCounter h0(hours, clkHour, KEY, editCur, editMode, disMode, SW[1]); // Manage Hours
	HexDisp uH(hours % 10, HEX6A); // Convert units of hours to 7-segment
	HexDisp tH(((hours - (hours % 10)) / 10) % 10, HEX7A); // Convert tens of hours to 7-segment
	
	//For 12-clock hour
	
	Clk24toClk12 clk2412(hours2, dayNight, hours); // Convert 24h-clock to 12h-clock
	HexDisp textDN(dayNight, HEX0A2); // Convert day/night to 7-segment
	HexDisp uH2(hours2 % 10, HEX6A2); // Convert units of 12h-clock hour to 7-segment
	HexDisp tH2(((hours2 - (hours2 % 10)) / 10) % 10, HEX7A2); // Convert tens of 12h-clock hour to 7-segment
	
	// Manage Mode and Keys
	
	KeysManage km0(editMode, disMode, editCur, KEY, SW[1], SW[2], CLOCK_50);
	
	// Assign blank 7-segment
	
	assign HEXF = 7'b111_1111;
	
	// Show mode through leds
	
	assign LEDR = (disMode == 0)? 3'b001: // Normal Mode
					(disMode == 1)? 3'b011: // DayMonth Mode
					(disMode == 2)? 3'b111: 3'b000; // TimeZone Mode __ Unknown Mode
	
	// Detect signals to control 7-segment theme
	
	always @(*) begin
		if (disMode == 0) begin // In Normal Mode
			if (SW[1] == 0) begin // When in 24h mode
				HEX7 <= (editMode == 1 && editCur == 0 && clkFlick == 1)? HEXF: HEX7A; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
				HEX6 <= (editMode == 1 && editCur == 1 && clkFlick == 1)? HEXF: HEX6A; // ...
				HEX0 <= 7'b111_1111; // blank
			end
			else begin // when in 12h mode
				HEX7 <= (editMode == 1 && editCur == 0 && clkFlick == 1)? HEXF: HEX7A2; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
				HEX6 <= (editMode == 1 && editCur == 0 && clkFlick == 1)? HEXF: HEX6A2; // ...
				HEX0 <= (editMode == 1 && editCur == 7 && clkFlick == 1)? HEXF: HEX0A2; // ...
			end
			// Common elements of 12h and 24h mode
			HEX5 <= (editMode == 1 && editCur == 2 && clkFlick == 1)? HEXF: HEX5A; // ...
			HEX4 <= (editMode == 1 && editCur == 3 && clkFlick == 1)? HEXF: HEX4A; // ...
			HEX3 <= (editMode == 1 && editCur == 4 && clkFlick == 1)? HEXF: HEX3A; // ...
			HEX2 <= (editMode == 1 && editCur == 5 && clkFlick == 1)? HEXF: HEX2A; // ...
			HEX1 <= 7'b111_1111; // blank
		end
		else if (disMode == 1) begin // In DayMonth Mode
			HEX7 <= 7'b100_1111; // 1
			HEX6 <= 7'b000_1111; // 1
			HEX5 <= 7'b100_1111; // 1
			HEX4 <= 7'b100_1111; // 7
			HEX3 <= 7'b001_0010; // 2
			HEX2 <= 7'b000_0001; // 0
			HEX1 <= 7'b100_1111; // 1
			HEX0 <= 7'b000_0100; // 9
		end
		else if (disMode == 2) begin // In TimeZone Mode
			HEX7 <= 7'b100_1110; // space ~ -/
			HEX6 <= 7'b111_1000; // + ~ /-
			HEX5 <= 7'b000_0001; // 0
			HEX4 <= 7'b000_1111; // 7
			HEX3 <= 7'b000_0001; // 0
			HEX2 <= 7'b000_0001; // 0
			HEX1 <= 7'b111_1111; // blank
			HEX0 <= 7'b111_1111; // blank
		end
	end
	
endmodule
